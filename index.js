import WebSocket from 'ws';
import fetch from 'node-fetch';

// ================= 配置区 =================
const APP_ID = '1906212850'; // 你的 AppID
const APP_SECRET = '你的QQ_AppSecret'; // 👈 必须替换成你刚重置的
const DEEPSEEK_KEY = '你的DeepSeek_API_Key'; // 👈 必须替换成你的 sk- 开头的 Key
// ==========================================

const API_BASE = 'https://api.sgroup.qq.com';

async function getToken() {
    const res = await fetch('https://bots.qq.com/app/getAppAccessToken', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ appId: APP_ID, clientSecret: APP_SECRET })
    });
    const data = await res.json();
    return data.access_token;
}

async function startBot() {
    const token = await getToken();
    const gatewayRes = await fetch(`${API_BASE}/gateway/bot`, {
        headers: { 'Authorization': `QQBot ${token}` }
    });
    const gatewayData = await gatewayRes.json();
    const wsUrl = gatewayData.url;
    
    const ws = new WebSocket(wsUrl);

    ws.on('open', () => console.log('✅ 已连接 QQ 服务器'));
    ws.on('close', () => setTimeout(startBot, 5000));

    ws.on('message', async (data) => {
        const payload = JSON.parse(data.toString());

        if (payload.op === 10) {
            ws.send(JSON.stringify({
                op: 2,
                d: { token: `QQBot ${token}`, intents: (1 << 25) | (1 << 30) }
            }));
            setInterval(() => {
                ws.send(JSON.stringify({ op: 1, d: Date.now() }));
            }, payload.d.heartbeat_interval || 30000);
        }

        if (payload.op === 0 && (payload.t === 'AT_MESSAGE_CREATE' || payload.t === 'MESSAGE_CREATE')) {
            const d = payload.d;
            const userMsg = d.content.replace(/<@!\d+>/g, '').trim();
            const channelId = d.channel_id;
            const msgId = d.id;
            if (!userMsg) return;

            try {
                const aiRes = await fetch('https://api.deepseek.com/chat/completions', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${DEEPSEEK_KEY}`
                    },
                    body: JSON.stringify({
                        model: 'deepseek-chat',
                        messages: [{ role: 'user', content: userMsg }]
                    })
                });
                const aiData = await aiRes.json();
                const reply = aiData.choices[0].message.content;

                await fetch(`${API_BASE}/channels/${channelId}/messages`, {
                    method: 'POST',
                    headers: {
                        'Authorization': `QQBot ${token}`,
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ content: reply, msg_id: msgId })
                });
            } catch (e) {}
        }
    });
}
startBot();
