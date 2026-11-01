<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover, interactive-widget=resizes-content">
<meta name="theme-color" content="#f5f7fb">
<title>studio Ultra v13.3.0</title>

<style>
/* ==================== 消息操作按钮 ==================== */
.msg { position: relative; }
.msg-tools { position: absolute; top: -6px; right: 0; display: flex; gap: 4px; opacity: 0; transform: translateY(4px); transition: .18s; z-index: 5; }
.msg.assistant .msg-tools { right: auto; left: 0; top: -10px; }
.msg:hover .msg-tools, .msg.show-tools .msg-tools { opacity: 1; transform: translateY(0); }
.msg-tool-btn { width: 28px; height: 28px; border-radius: 8px; background: var(--card-bg); border: 1px solid var(--border); color: var(--text-muted); font-size: 13px; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 8px rgba(0,0,0,.1); backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px); }
.msg-tool-btn:hover { color: var(--accent); border-color: rgba(79,109,245,.4); }
.msg-tool-btn.danger:hover { color: #ef4444; border-color: rgba(239,68,68,.4); }
@media (max-width: 767px) {
  .msg-tools { opacity: 1; transform: none; }
}
/* ==================== 基础与平滑动画 ==================== */
* { box-sizing: border-box; margin: 0; padding: 0; -webkit-tap-highlight-color: transparent; }
html, body { height: 100%; overflow: hidden; }
body {
  font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "PingFang SC", sans-serif;
  background: var(--bg-color); color: var(--text-color); -webkit-font-smoothing: antialiased;
  transition: background .3s ease, color .3s ease;
}
button, input, textarea { touch-action: manipulation; outline: none; transition: all 0.2s ease; }
button { font-family: inherit; cursor: pointer; user-select: none; border: none; background: none; }
button:active { transform: scale(.96); }

:root {
  --bg-color: #f5f7fb; --bg-gradient: linear-gradient(180deg, #eef1f7, #f7f9fc);
  --text-color: #1f2937; --text-muted: #6b7280;
  --glass: rgba(255,255,255,.8); --border: rgba(15,23,42,.06);
  --card-bg: rgba(255,255,255,.85); --card-shadow: 0 4px 18px rgba(15,23,42,.05);
  --accent: #4f6df5; --blur: blur(15px);
  --bubble-user: linear-gradient(135deg, #303748, #161b26); --bubble-ai: #fff;
}
body.dark {
  --bg-color: #121212; --bg-gradient: linear-gradient(180deg, #1a1a1a, #121212);
  --text-color: #e5e7eb; --text-muted: #9ca3af;
  --glass: rgba(30,30,30,.8); --border: rgba(255,255,255,.08);
  --card-bg: rgba(30,30,30,.85); --card-shadow: 0 4px 18px rgba(0,0,0,.3);
  --bubble-user: linear-gradient(135deg, #4f46e5, #312e81); --bubble-ai: #1f2937;
}

#particleCanvas { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; pointer-events: none; z-index: 0; }

/* ==================== 自定义背景层 ==================== */
#customBg {
  position: fixed; inset: 0; z-index: 0; pointer-events: none;
  background-size: cover; background-position: center; background-repeat: no-repeat;
  opacity: 0; transition: opacity .35s ease; display: none;
}
#customBg.active { display: block; }

/* ==================== 布局骨架 ==================== */
#app { height: 100dvh; display: flex; position: relative; z-index: 1; background: transparent; }
#main { flex: 1; min-width: 0; min-height: 0; display: flex; flex-direction: column; position: relative; }
.view { flex: 1; min-height: 0; display: flex; flex-direction: column; position: relative; transition: opacity 0.3s ease; }
.view.hidden, .hidden { display: none !important; }

/* 侧边栏 */
#sidebar { display: flex; flex-direction: column; background: var(--glass); -webkit-backdrop-filter: var(--blur); backdrop-filter: var(--blur); border-right: 1px solid var(--border); width: 272px; flex-shrink: 0; z-index: 45; transition: transform 0.3s cubic-bezier(0.2, 0.8, 0.2, 1); }
.side-logo { display: flex; align-items: center; gap: 10px; padding: 18px 16px 12px; }
.logo-mark { width: 38px; height: 38px; border-radius: 12px; background: linear-gradient(135deg, #5b7cfa, #8b5cf6); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 18px; }
.side-logo b { font-size: 17px; }
.side-logo small { display: block; color: var(--text-muted); font-size: 10.5px; }
.new-chat-btn { margin: 4px 14px 10px; padding: 11px; border-radius: 12px; border: 1px dashed rgba(79,109,245,.5); background: rgba(79,109,245,.07); color: var(--accent); font-weight: 700; font-size: 13.5px; display: flex; align-items: center; justify-content: center; gap: 6px; }
.session-label { padding: 4px 16px 6px; font-size: 11px; color: var(--text-muted); font-weight: 700; }
.session-list { flex: 1; overflow-y: auto; min-height: 0; padding: 2px 10px 10px; }
.sess-item { display: flex; align-items: center; gap: 6px; padding: 9px 10px; border-radius: 11px; cursor: pointer; margin-bottom: 2px; border: 1px solid transparent; transition: 0.2s; }
.sess-item:hover { background: rgba(120,120,128,.1); }
.sess-item.active { background: rgba(79,109,245,.1); border-color: rgba(79,109,245,.2); }
.sess-title { font-size: 13.5px; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.sess-tag { font-size: 9px; background: rgba(0,0,0,.1); padding: 1px 4px; border-radius: 4px; margin-left: 4px; }
body.dark .sess-tag { background: rgba(255,255,255,.1); }
.sess-del { opacity: 0; font-size: 12px; padding: 4px; color: #ef4444; transition: 0.2s; }
.sess-item:hover .sess-del { opacity: 1; }
.side-nav { border-top: 1px solid var(--border); padding: 8px 10px calc(10px + env(safe-area-inset-bottom)); }
.side-nav button { width: 100%; display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 11px; font-size: 13.5px; font-weight: 600; color: var(--text-color); }
.side-nav button.active { background: rgba(79,109,245,.1); color: var(--accent); }
#overlay { display: none; transition: opacity 0.3s; }

/* 顶部 Header */
.topbar { display: flex; align-items: center; gap: 10px; padding: 10px 14px; background: var(--glass); -webkit-backdrop-filter: var(--blur); backdrop-filter: var(--blur); border-bottom: 1px solid var(--border); z-index: 20; flex-shrink: 0; }
.topbar-title { flex: 1; font-size: 15px; font-weight: 700; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.icon-btn { width: 36px; height: 36px; border-radius: 11px; background: rgba(120,120,128,.1); font-size: 17px; color: var(--text-color); display: flex; align-items: center; justify-content: center; }
#menuBtn { display: none; }

/* ==================== 聊天区 ==================== */
.chat-scroll { flex: 1; overflow-y: auto; min-height: 0; padding: 16px 14px 20px; z-index: 2; scroll-behavior: smooth; }
.chat-scroll-inner, .debate-scroll-inner { max-width: 860px; margin: 0 auto; width: 100%; }
.msg { display: flex; margin: 10px 0; animation: slideUp 0.3s ease; }
@keyframes slideUp { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
.msg.user { justify-content: flex-end; }
.msg.user .bubble { background: var(--bubble-user); color: #f8fafc; border-radius: 18px 18px 6px 18px; padding: 11px 14px; max-width: 82%; font-size: 15px; line-height: 1.6; position: relative; z-index: 2; }
.msg.assistant .bubble { background: var(--bubble-ai); color: var(--text-color); border: 1px solid var(--border); border-radius: 18px 18px 18px 6px; padding: 12px 14px 8px; max-width: 90%; box-shadow: var(--card-shadow); position: relative; z-index: 2; }
.msg-model { display: flex; align-items: center; gap: 6px; font-size: 11px; font-weight: 700; color: var(--text-muted); margin-bottom: 6px; }
.md { font-size: 15px; line-height: 1.7; word-break: break-word; }
.md pre { background: #0f172a; color: #e2e8f0; border-radius: 12px; padding: 12px 14px; overflow-x: auto; margin: 8px 0; font-size: 13px; font-family: monospace; }
.md code { background: rgba(120,120,128,.15); padding: 2px 6px; border-radius: 6px; font-size: .9em; color: #c2410c; }
body.dark .md code { color: #fca5a5; }

/* Markdown 扩展样式 */
.md-p { margin: 6px 0; }
.md-h { margin: 12px 0 6px; font-weight: 800; line-height: 1.4; }
.md-list { margin: 6px 0 6px 20px; }
.md-list li { margin: 3px 0; }
.md-quote { margin: 8px 0; padding: 6px 12px; border-left: 3px solid var(--accent); background: rgba(79,109,245,.07); border-radius: 0 8px 8px 0; color: var(--text-muted); font-size: 14px; }
.md-hr { border: none; border-top: 1px dashed var(--border); margin: 12px 0; }
.md-table-wrap { width: 100%; overflow-x: auto; margin: 10px 0; border-radius: 10px; border: 1px solid var(--border); }
.md table { width: 100%; border-collapse: collapse; font-size: 13.5px; }
.md th, .md td { border: 1px solid var(--border); padding: 7px 10px; text-align: left; vertical-align: top; }
.md th { background: rgba(120,120,128,.1); font-weight: 800; white-space: nowrap; }
.md tbody tr:nth-child(even) { background: rgba(120,120,128,.04); }

/* 输入区 */
.down-btn { position: absolute; left: 50%; bottom: 150px; transform: translateX(-50%) translateY(8px); z-index: 15; width: 40px; height: 40px; border-radius: 50%; border: 1px solid var(--border); background: var(--glass); color: var(--text-color); font-size: 17px; box-shadow: 0 6px 20px rgba(0,0,0,.14); opacity: 0; pointer-events: none; transition: .22s; display: flex; align-items: center; justify-content: center; }
.down-btn.show { opacity: .92; pointer-events: auto; transform: translateX(-50%) translateY(0); }

.inputbar { flex-shrink: 0; padding: 8px 12px calc(10px + env(safe-area-inset-bottom)); background: var(--glass); -webkit-backdrop-filter: var(--blur); backdrop-filter: var(--blur); border-top: 1px solid var(--border); z-index: 10; position: relative; }

/* 提示条：未绑定 API */
.api-warning-bar { position: absolute; top: -52px; left: 12px; right: 12px; background: rgba(239, 246, 255, 0.95); border: 1px solid #bfdbfe; border-radius: 12px; padding: 8px 14px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 15px rgba(0,0,0,.08); backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px); opacity: 0; pointer-events: none; transform: translateY(10px); transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1); z-index: 20; }
.api-warning-bar.show { opacity: 1; pointer-events: auto; transform: translateY(0); }
.api-warning-text { font-size: 13px; color: #1e3a8a; font-weight: 600; }
.api-warning-link { font-size: 13px; color: #2563eb; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 4px; }
.api-warning-link::after { content: '→'; font-size: 15px; }

/* 工具条 */
.toolbar-row { display: flex; justify-content: center; align-items: center; gap: 8px; margin-bottom: 8px; position: relative; }

/* ChatGPT 滑块 */
.strength-wrapper { position: relative; display: flex; justify-content: center; margin-bottom: 8px; }
.strength-toggle { display: inline-flex; align-items: center; gap: 6px; padding: 6px 14px; background: var(--bubble-ai); border: 1px solid var(--border); border-radius: 20px; font-size: 13px; font-weight: 700; color: var(--text-color); box-shadow: 0 2px 8px rgba(0,0,0,0.05); transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1); }
.strength-toggle:active { transform: scale(0.95); }
.strength-expanded { position: absolute; bottom: 100%; left: 50%; transform: translateX(-50%) scale(0.9) translateY(10px); width: 288px; background: var(--glass); padding: 16px 20px; border-radius: 20px; border: 1px solid var(--border); box-shadow: 0 10px 30px rgba(0,0,0,0.15); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); opacity: 0; pointer-events: none; transition: all 0.25s cubic-bezier(0.2, 0.9, 0.3, 1.2); z-index: 40; margin-bottom: 12px; }
.strength-expanded.open { opacity: 1; pointer-events: auto; transform: translateX(-50%) scale(1) translateY(0); }
.slider-track { position: relative; height: 32px; display: flex; align-items: center; touch-action: none; cursor: pointer; }
.slider-bg { position: absolute; left: 0; right: 0; height: 8px; background: rgba(120,120,128,.2); border-radius: 4px; }
.slider-fill { position: absolute; left: 0; height: 8px; border-radius: 4px; background: #10b981; transition: width 0.1s, background 0.3s; }
.slider-thumb { position: absolute; top: 50%; width: 28px; height: 28px; background: #fff; border-radius: 50%; box-shadow: 0 2px 10px rgba(0,0,0,0.2); transform: translate(-50%, -50%); pointer-events: none; z-index: 2; border: 3.5px solid #10b981; transition: left 0.1s, border-color 0.3s; }
.slider-thumb:active { transform: translate(-50%, -50%) scale(1.15); }
#strengthRange { position: absolute; left: 0; width: 100%; height: 100%; opacity: 0; z-index: 3; cursor: pointer; -webkit-appearance: none; margin: 0; }
.slider-labels { display: flex; justify-content: space-between; margin-top: 8px; }
.slider-labels span { font-size: 11px; font-weight: 700; color: var(--text-muted); transition: color 0.2s; }
.slider-labels span.active { color: var(--accent); }

/* 双倍检查开关 */
.selfcheck-row { display: flex; align-items: center; justify-content: space-between; gap: 10px; padding-bottom: 10px; margin-bottom: 12px; border-bottom: 1px dashed var(--border); }
.sc-left { display: flex; align-items: center; gap: 8px; min-width: 0; }
.sc-ico { width: 26px; height: 26px; flex-shrink: 0; border-radius: 9px; display: flex; align-items: center; justify-content: center; font-size: 14px; background: rgba(245,158,11,.14); border: 1px solid rgba(245,158,11,.35); transition: all .3s; }
.selfcheck-on .sc-ico { background: rgba(245,158,11,.28); box-shadow: 0 0 12px rgba(245,158,11,.5); }
.sc-name { font-size: 12.5px; font-weight: 800; line-height: 1.25; }
.sc-desc { font-size: 10px; color: var(--text-muted); margin-top: 1px; white-space: nowrap; }
.sc-switch { position: relative; display: inline-flex; padding: 2px; flex-shrink: 0; border-radius: 999px; background: rgba(120,120,128,.16); border: 1px solid var(--border); overflow: hidden; }
.sc-switch::before { content: ''; position: absolute; top: 50%; left: 50%; width: 220%; aspect-ratio: 1; background: conic-gradient(from 0deg, #f59e0b, #fff3c4, #8b5cf6, #f59e0b, #f59e0b); transform: translate(-50%, -50%); opacity: 0; transition: opacity .25s; z-index: 0; }
.sc-switch[data-on="1"]::before { opacity: 1; animation: scSpin 2.4s linear infinite; }
@keyframes scSpin { to { transform: translate(-50%, -50%) rotate(360deg); } }
.sc-thumb { position: absolute; top: 2px; left: 2px; height: calc(100% - 4px); width: calc(50% - 2px); border-radius: 999px; background: var(--card-bg); box-shadow: 0 1px 5px rgba(0,0,0,.2); z-index: 1; transition: transform .3s cubic-bezier(.2,.9,.3,1.2); }
.sc-switch[data-on="1"] .sc-thumb { transform: translateX(100%); }
.sc-seg { position: relative; z-index: 2; width: 52px; text-align: center; font-size: 11px; font-weight: 800; padding: 5px 0; color: var(--text-muted); transition: color .25s; }
.sc-switch[data-on="0"] .sc-off { color: var(--text-color); }
.sc-switch[data-on="1"] .sc-on { color: #b45309; }

/* 面板底部提示 */
.panel-hints { margin-top: 10px; padding-top: 8px; border-top: 1px dashed var(--border); display: flex; flex-direction: column; gap: 5px; }
.panel-hint { font-size: 10.5px; line-height: 1.45; color: var(--text-muted); display: flex; align-items: flex-start; gap: 5px; }
.panel-hint.warn { color: #b45309; }
body.dark .panel-hint.warn { color: #fbbf24; }

/* 胶囊上的小角标 */
.sc-badge { display: none; font-size: 9px; font-weight: 800; line-height: 1; color: #b45309; background: rgba(245,158,11,.18); border: 1px solid rgba(245,158,11,.45); padding: 2px 5px; border-radius: 999px; margin-left: 2px; }
.sc-badge.show { display: inline-block; animation: scBadgePulse 1.8s ease-in-out infinite; }
@keyframes scBadgePulse { 0%,100% { box-shadow: 0 0 0 0 rgba(245,158,11,.5); } 50% { box-shadow: 0 0 0 4px rgba(245,158,11,0); } }
.tier-warn { display: none; width: 14px; height: 14px; border-radius: 50%; align-items: center; justify-content: center; font-size: 9px; font-weight: 800; color: #b45309; background: rgba(245,158,11,.18); border: 1px solid rgba(245,158,11,.45); }
.tier-warn.show { display: inline-flex; }

/* 回答里的状态条 */
.sc-status { margin-top: 8px; font-size: 11.5px; font-weight: 700; color: var(--text-muted); display: inline-flex; align-items: center; gap: 6px; }
.sc-status::after { content: ''; width: 10px; height: 10px; border-radius: 50%; border: 2px solid rgba(245,158,11,.3); border-top-color: #f59e0b; animation: scSpinDot .7s linear infinite; }
.sc-status.done { color: #10b981; }
.sc-status.fail { color: #ef4444; }
.sc-status.done::after, .sc-status.fail::after { display: none; }
@keyframes scSpinDot { to { transform: rotate(360deg); } }
.sc-flag { margin-left: auto; font-size: 9.5px; font-weight: 800; color: #b45309; background: rgba(245,158,11,.16); border: 1px solid rgba(245,158,11,.4); padding: 1px 6px; border-radius: 999px; }

/* 能力胶囊 */
.cap-wrapper { position: relative; }
.cap-toggle { display: inline-flex; align-items: center; gap: 6px; padding: 6px 14px; background: var(--bubble-ai); border: 1px solid var(--border); border-radius: 20px; font-size: 13px; font-weight: 700; color: var(--text-color); box-shadow: 0 2px 8px rgba(0,0,0,0.05); transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1); }
.cap-toggle.has-on { color: var(--accent); border-color: rgba(79,109,245,.45); background: rgba(79,109,245,.09); }
.cap-count { font-size: 10px; line-height: 1; background: var(--accent); color: #fff; border-radius: 999px; padding: 3px 5px; font-weight: 800; }
.cap-panel { position: absolute; bottom: calc(100% + 10px); left: 50%; transform: translateX(-50%) scale(.92) translateY(8px); width: min(320px, 86vw); background: var(--glass); -webkit-backdrop-filter: blur(20px); backdrop-filter: blur(20px); border: 1px solid var(--border); border-radius: 20px; box-shadow: 0 12px 40px rgba(0,0,0,.18); padding: 12px; opacity: 0; pointer-events: none; transition: all .25s cubic-bezier(.2,.9,.3,1.2); z-index: 50; }
.cap-panel.open { opacity: 1; pointer-events: auto; transform: translateX(-50%) scale(1) translateY(0); }
.cap-title { font-size: 11px; font-weight: 800; color: var(--text-muted); padding: 4px 8px 8px; }
.cap-item { display: flex; align-items: center; gap: 10px; padding: 9px 8px; border-radius: 12px; cursor: pointer; transition: .2s; }
.cap-item:hover { background: rgba(120,120,128,.1); }
.cap-item.on { background: rgba(79,109,245,.09); }
.cap-check { width: 20px; height: 20px; flex-shrink: 0; border-radius: 6px; border: 1.5px solid var(--border); display: flex; align-items: center; justify-content: center; font-size: 12px; color: transparent; transition: .2s; }
.cap-item.on .cap-check { background: var(--accent); border-color: var(--accent); color: #fff; }
.cap-name { font-size: 13px; font-weight: 700; }
.cap-desc { font-size: 11px; color: var(--text-muted); margin-top: 2px; }

.input-row { display: flex; align-items: flex-end; gap: 8px; background: var(--bubble-ai); border: 1px solid var(--border); border-radius: 18px; padding: 7px 7px 7px 14px; box-shadow: var(--card-shadow); transition: border-color 0.2s; }
.input-row:focus-within { border-color: var(--accent); }
#chatInput { flex: 1; border: none; background: transparent; font-size: 16px; line-height: 1.5; max-height: 140px; padding: 6px 0; color: var(--text-color); }
.send-btn { width: 38px; height: 38px; border-radius: 50%; background: linear-gradient(135deg, #5b7cfa, #8b5cf6); color: #fff; font-size: 18px; flex-shrink: 0; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 12px rgba(91,124,250,.3); }

/* ==================== 聊天毛玻璃效果 ==================== */
.msg.assistant .bubble {
  background: rgba(255, 255, 255, 0.55);
  -webkit-backdrop-filter: blur(16px) saturate(1.5);
  backdrop-filter: blur(16px) saturate(1.5);
}
body.dark .msg.assistant .bubble {
  background: rgba(31, 41, 55, 0.5);
  border-color: rgba(255,255,255,.12);
}
.msg.user .bubble {
  background: rgba(40, 46, 60, 0.72);
  -webkit-backdrop-filter: blur(16px) saturate(1.4);
  backdrop-filter: blur(16px) saturate(1.4);
}
.input-row {
  background: rgba(255, 255, 255, 0.55);
  -webkit-backdrop-filter: blur(16px) saturate(1.5);
  backdrop-filter: blur(16px) saturate(1.5);
}
body.dark .input-row {
  background: rgba(31, 41, 55, 0.5);
}

/* ==================== 辩论区 ==================== */
.debate-scroll { flex: 1; overflow-y: auto; min-height: 0; padding: 14px 14px 24px; z-index: 2; }
.card { background: var(--card-bg); border: 1px solid var(--border); border-radius: 18px; box-shadow: var(--card-shadow); margin-bottom: 14px; padding: 16px; }
.card h2 { font-size: 16px; margin-bottom: 6px; }
.debate-config label { font-size: 12px; font-weight: 700; color: var(--text-muted); display: block; margin: 12px 0 6px; }
.set-input { width: 100%; border: 1px solid var(--border); border-radius: 12px; padding: 10px; font-size: 15px; background: var(--bg-color); color: var(--text-color); margin-bottom: 8px; }
.config-row { display: flex; gap: 10px; flex-wrap: wrap; }
.config-col { flex: 1; min-width: 140px; }
.api-estimate { font-size: 12px; color: var(--accent); background: rgba(79,109,245,.1); padding: 6px 10px; border-radius: 8px; display: inline-block; margin-top: 8px; }
.debate-card { background: var(--bubble-ai); border: 1px solid var(--border); border-radius: 14px; padding: 14px; margin-bottom: 14px; }
.round-head { display: flex; flex-wrap: wrap; align-items: center; gap: 8px; margin-bottom: 10px; border-bottom: 1px solid var(--border); padding-bottom: 8px; }
.round-title { font-weight: 800; font-size: 14px; }
.round-tag { font-size: 11px; font-weight: 700; color: var(--text-muted); background: rgba(120,120,128,.12); padding: 2px 8px; border-radius: 999px; }
.ans { border: 1px solid var(--border); border-radius: 12px; padding: 11px; margin-bottom: 8px; background: var(--bg-color); }
.ans-head { font-size: 12px; font-weight: 800; color: var(--text-muted); margin-bottom: 6px; display: flex; justify-content: space-between; }
.ans-body { font-size: 13.5px; line-height: 1.7; }

.fusion-card { margin: 18px 0; background: radial-gradient(120% 140% at 20% 0%, #3a2c12 0%, #17110a 100%); border: 1.5px solid #d4af37; border-radius: 20px; padding: 20px; color: #f7ecd0; box-shadow: 0 10px 40px rgba(212,175,55,.15); }
.fusion-head { font-size: 17px; font-weight: 800; color: #ffe9a8; display: flex; align-items: center; gap: 8px; }
.fusion-meta { font-size: 11px; color: rgba(247,236,208,.6); margin: 4px 0 12px; }
.fusion-body { font-size: 14px; line-height: 1.75; }
.fusion-card .md { color: #f7ecd0; }
.fusion-card .md strong { color: #ffe9a8; }
.fusion-card .md code { background: rgba(255,255,255,.12); color: #ffe9a8; }
.fusion-card .md th, .fusion-card .md td { border-color: rgba(255,233,168,.25); }
.fusion-card .md th { background: rgba(255,233,168,.12); color: #ffe9a8; }
.fusion-card .md tbody tr:nth-child(even) { background: rgba(255,255,255,.04); }
.fusion-card .md-quote { border-left-color: #d4af37; background: rgba(255,233,168,.08); color: rgba(247,236,208,.85); }
.fusion-actions { display: flex; gap: 10px; margin-top: 15px; }
.fusion-btn { flex: 1; padding: 10px; background: linear-gradient(135deg, #e8c15a, #b8912e); color: #241a05; font-weight: 800; border-radius: 10px; transition: opacity 0.2s; }

/* ==================== 设置页 ==================== */
.settings-scroll { flex: 1; overflow-y: auto; min-height: 0; padding: 16px 14px 24px; max-width: 640px; margin: 0 auto; width: 100%; z-index: 2; }
.set-card h3 { font-size: 15px; margin-bottom: 8px; display: flex; align-items: center; justify-content: space-between; }
.set-card h3 .status-dot { width: 8px; height: 8px; border-radius: 50%; background: #cbd5e1; transition: 0.3s; }
.set-card h3 .status-dot.ok { background: #10b981; box-shadow: 0 0 8px rgba(16,185,129,.4); }
.set-card p { font-size: 12.5px; color: var(--text-muted); margin-bottom: 10px; }
.set-btn { padding: 10px 16px; border-radius: 11px; background: rgba(79,109,245,.1);
   color: var(--accent); font-weight: 700; font-size: 13px; margin: 4px 8px 0 0; }
.set-btn.danger { background: rgba(220,38,38,.08); color: #dc2626; }
.test-btn { background: rgba(16,185,129,.1); color: #10b981; }

/* 头像上传 */
.avatar-row { display: flex; align-items: center; gap: 14px; margin-bottom: 10px; }
.avatar-preview { width: 64px; height: 64px; border-radius: 50%; border: 3px solid #fff; box-shadow: 0 4px 14px rgba(0,0,0,.15); background: #fff; overflow: hidden; display: flex; align-items: center; justify-content: center; font-size: 32px; }
.avatar-preview img { width: 100%; height: 100%; object-fit: cover; }

/* 用量与额度 */
.usage-list { display: flex; flex-direction: column; gap: 10px; margin-top: 10px; }
.usage-item { display: flex; flex-direction: column; gap: 6px; background: var(--bg-color); padding: 12px; border-radius: 10px; border: 1px solid var(--border); font-size: 13px; }
.usage-top { display: flex; justify-content: space-between; align-items: center; }
.usage-name { font-weight: 600; display: flex; align-items: center; gap: 6px; }
.usage-tokens { color: var(--text-muted); font-family: monospace; font-size: 12px; }
.quota-bar-wrap { width: 100%; height: 6px; background: rgba(120,120,128,.15); border-radius: 3px; overflow: hidden; margin-top: 4px; }
.quota-bar-fill { height: 100%; border-radius: 3px; transition: width 0.4s ease, background 0.3s; }
.quota-bar-text { font-size: 10px; color: var(--text-muted); text-align: right; margin-top: 2px; }

/* 模型下拉 */
.dd { position: relative; }
.dd-btn { display: flex; align-items: center; gap: 7px; padding: 8px 12px; border-radius: 999px; border: 1px solid var(--border); background: var(--bubble-ai); font-size: 13px; font-weight: 700; color: var(--text-color); max-width: 150px; overflow: hidden; text-overflow: ellipsis; }
.dd-menu { position: absolute; top: calc(100% + 8px); right: 0; min-width: 260px; background: var(--card-bg); border: 1px solid var(--border); border-radius: 14px; box-shadow: 0 12px 36px rgba(0,0,0,.2); padding: 6px; z-index: 60; display: none; max-height: 400px; overflow-y: auto; }
.dd-menu.open { display: block; animation: popIn .2s cubic-bezier(0.16, 1, 0.3, 1); }
@keyframes popIn { from { opacity: 0; transform: scale(.95) translateY(-10px); } to { opacity: 1; transform: scale(1) translateY(0); } }
.dd-group-title { font-size: 11px; font-weight: 800; color: var(--text-muted); padding: 10px 10px 4px; display: flex; align-items: center; gap: 6px; }
.dd-group-title .g-dot { width: 6px; height: 6px; border-radius: 50%; background: #cbd5e1; transition: 0.3s; }
.dd-group-title .g-dot.ok { background: #10b981; box-shadow: 0 0 6px rgba(16,185,129,.5); }
.dd-item { display: flex; align-items: center; gap: 8px; width: 100%; padding: 10px 12px 10px 22px; border-radius: 10px; font-size: 13px; font-weight: 600; color: var(--text-color); text-align: left; transition: 0.2s; }
.dd-item:hover { background: rgba(120,120,128,.1); }
.dd-item.active { background: rgba(79,109,245,.1); color: var(--accent); }
.dd-item.disabled { opacity: 0.4; cursor: not-allowed; }
.dd-item .free-tag { font-size: 10px; background: #10b981; color: #fff; padding: 1px 4px; border-radius: 4px; margin-left: auto; }
.dd-item .paid-tag { font-size: 10px; background: #f59e0b; color: #fff; padding: 1px 4px; border-radius: 4px; margin-left: auto; }

/* 悬浮助手 */
#floatAssistant { position: fixed; z-index: 70; width: 72px; height: 72px; cursor: grab; touch-action: none; transition: transform 0.4s cubic-bezier(0.2, 0.8, 0.2, 1), left 0.1s, top 0.1s; }
#floatAssistant.dragging { cursor: grabbing; transition: none; }
#floatAssistant.edge-left { transform: translateX(-60%); }
#floatAssistant.edge-right { transform: translateX(60%); }
.assistant-ring { position: absolute; inset: 0; border-radius: 50%; background: conic-gradient(from 0deg, #ff9ec0, #7c8cff, #53e0c8, #ff9ec0); animation: ringSpin 6s linear infinite; box-shadow: 0 4px 15px rgba(79,109,245,.3); }
.assistant-core { position: absolute; inset: 4px; border-radius: 50%; overflow: hidden; background: #fff; display: flex; align-items: center; justify-content: center; font-size: 32px; }
.assistant-core img { width: 100%; height: 100%; object-fit: cover; }
.assistant-bubble { position: absolute; right: -10px; bottom: calc(100% + 14px); width: 240px; background: #fff; border: 3px solid #16337a; border-radius: 16px; box-shadow: 6px 7px 0 rgba(22,51,122,.16); padding: 13px 14px; display: none; z-index: 3; color: #16337a; transition: 0.2s; }
.assistant-bubble.open { display: block; animation: popIn .18s ease; }
.assistant-bubble .arrow { position: absolute; bottom: -14px; right: 30px; border-left: 12px solid transparent; border-right: 12px solid transparent; border-top: 14px solid #16337a; }
.assistant-bubble .arrow::after { content: ''; position: absolute; left: -9px; top: -15px; border-left: 9px solid transparent; border-right: 9px solid transparent; border-top: 10px solid #fff; }
.assistant-bubble.below { bottom: auto; top: calc(100% + 14px); }
.assistant-bubble.below .arrow { bottom: auto; top: -14px; transform: rotate(180deg); }
.assistant-bubble.align-left { right: auto; left: -10px; }
.assistant-bubble.align-left .arrow { right: auto; left: 30px; }
.assistant-bubble .fold { position: absolute; top: -3px; right: -3px; width: 20px; height: 20px; background: #e4eafc; clip-path: polygon(100% 0, 0 100%, 100% 100%); }
.ab-head { font-weight: 800; font-size: 14px; margin-bottom: 8px; display: flex; align-items: center; gap: 6px; }
.ab-body { font-size: 12.5px; line-height: 1.6; color: #5b6d99; }
.ab-row { display: flex; justify-content: space-between; border-bottom: 1px dashed #d7e2fb; padding: 6px 0; }
.ab-row:last-child { border-bottom: none; }
.ab-row b { color: #16337a; font-family: monospace; font-size: 13px; }

#toast { position: fixed; left: 50%; bottom: 160px; transform: translateX(-50%) translateY(12px); background: rgba(17,24,39,.95); color: #fff; padding: 10px 18px; border-radius: 20px; font-size: 13px; z-index: 90; opacity: 0; transition: .25s ease; pointer-events: none; max-width: 86%; text-align: center; }
#toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }
#toast.toast-has-action { display: flex; align-items: center; justify-content: center; gap: 10px; flex-wrap: wrap; padding: 10px 14px; pointer-events: auto; }
#toast .toast-action { pointer-events: auto; flex-shrink: 0; background: rgba(255,255,255,.18); border: 1px solid rgba(255,255,255,.5); color: #fff; font-size: 12px; font-weight: 800; padding: 5px 11px; border-radius: 999px; white-space: nowrap; animation: toastPulse 1.6s ease-in-out infinite; }
@keyframes toastPulse { 0%,100% { box-shadow: 0 0 0 0 rgba(255,255,255,.35); } 50% { box-shadow: 0 0 0 6px rgba(255,255,255,0); } }

@keyframes ringSpin { to { transform: rotate(360deg); } }
.tabbar { display: none !important; }
@media (min-width: 768px) { #menuBtn { display: none; } }
@media (max-width: 767px) {
  #menuBtn { display: flex; }
  #sidebar { position: fixed; top: 0; bottom: 0; left: 0; height: 100dvh; width: min(80vw, 300px); transform: translateX(-105%); z-index: 100; background: var(--bg-color); }
  #sidebar.open { transform: translateX(0); }
  #overlay { position: fixed; inset: 0; background: rgba(0,0,0,.5); z-index: 99; opacity: 0; pointer-events: none; }
  #overlay.show { opacity: 1; pointer-events: auto; }
}
</style>
</head>
<body>

<div id="customBg"></div>
<canvas id="particleCanvas"></canvas>

<div id="app">
  <aside id="sidebar">
    <div class="side-logo">
      <div class="logo-mark">⚡</div>
      <div><b>studio Ultra</b><small>v13.3.0 旗舰版</small></div>
    </div>
    <button id="newChatSideBtn" class="new-chat-btn">＋ 新建对话</button>
    <div class="session-label">对话记录</div>
    <div id="sessionList" class="session-list"></div>
    <div class="side-nav">
      <button id="navDebateBtn">⚔️ 多 Agent 辩论</button>
      <button id="navSettingsBtn">⚙️ 设置</button>
    </div>
  </aside>
  <div id="overlay"></div>

  <div id="main">
    <header class="topbar">
      <button id="menuBtn" class="icon-btn" title="打开侧边栏" aria-label="打开侧边栏">☰</button>
      <div id="topbarTitle" class="topbar-title">新对话</div>
      <button id="newChatBtn" class="icon-btn" title="新建对话">＋</button>
      <div id="chatModelDD"></div>
    </header>

    <div id="chatView" class="view">
      <div id="chatScroll" class="chat-scroll">
        <div id="chatInner" class="chat-scroll-inner"></div>
      </div>
      <button id="downBtn" class="down-btn">↓</button>
      
      <div class="inputbar">
        <div class="api-warning-bar" id="apiWarningBar">
          <span class="api-warning-text" id="apiWarnText">该模型未绑定 API</span>
          <span class="api-warning-link" id="apiWarnLink">去添加</span>
        </div>

        <div class="toolbar-row">
          <div class="strength-wrapper">
            <button id="strengthToggle" class="strength-toggle">
              <span id="toggleText">⚡ 中</span>
              <span class="sc-badge" id="scBadge">⚡2×</span>
              <span class="tier-warn" id="tierWarn" title="当前模型不支持细分档位">!</span>
              <span id="strengthArrow" style="font-size:10px; opacity:0.5; margin-left:2px;">▲</span>
            </button>
            
            <div class="strength-expanded" id="strengthExpanded">
              <div class="selfcheck-row" id="selfCheckRow">
                <div class="sc-left">
                  <span class="sc-ico">⚡</span>
                  <div>
                    <div class="sc-name">双倍检查</div>
                    <div class="sc-desc">自我检查 · 两遍生成</div>
                  </div>
                </div>
                <button class="sc-switch" id="scSwitch" type="button" aria-pressed="false" data-on="0">
                  <span class="sc-thumb"></span>
                  <span class="sc-seg sc-off">未开启</span>
                  <span class="sc-seg sc-on">开启</span>
                </button>
              </div>

              <div class="slider-track">
                <div class="slider-bg"></div>
                <div class="slider-fill" id="sliderFill"></div>
                <div class="slider-thumb" id="sliderThumb"></div>
                <input type="range" id="strengthRange" min="0" max="4" step="1" value="2">
              </div>
              <div class="slider-labels">
                <span data-i="0">极低</span>
                <span data-i="1">低</span>
                <span data-i="2" class="active">中</span>
                <span data-i="3">高</span>
                <span data-i="4">Ultra</span>
              </div>

              <div class="panel-hints">
                <div class="panel-hint" id="tierHint"></div>
                <div class="panel-hint" id="checkHint"></div>
              </div>
            </div>
          </div>

          <div class="cap-wrapper" id="capWrapper">
            <button id="capToggle" class="cap-toggle">
              <span>✨ 能力</span>
              <span class="cap-count hidden" id="capCount">0</span>
              <span id="capArrow" style="font-size:10px; opacity:0.5; margin-left:2px;">▲</span>
            </button>
            <div class="cap-panel" id="capPanel">
              <div class="cap-title">回复能力（可多选，即时生效）</div>
              <div class="cap-item" data-cap="table">
                <span class="cap-check">✓</span>
                <div><div class="cap-name">📊 表格化输出</div><div class="cap-desc">对比、参数、方案用表格罗列</div></div>
              </div>
              <div class="cap-item" data-cap="rigorous">
                <span class="cap-check">✓</span>
                <div><div class="cap-name">🔬 严谨分析</div><div class="cap-desc">结论先行，再列论据、假设与风险</div></div>
              </div>
              <div class="cap-item" data-cap="annotate">
                <span class="cap-check">✓</span>
                <div><div class="cap-name">📌 文中标注</div><div class="cap-desc">关键结论后就地标注依据/来源</div></div>
              </div>
              <div class="cap-item" data-cap="format">
                <span class="cap-check">✓</span>
                <div><div class="cap-name">📐 格式规范</div><div class="cap-desc">标题/分点/层级统一排版</div></div>
              </div>
            </div>
          </div>
        </div>

        <div class="input-row">
          <textarea id="chatInput" rows="1" placeholder="给 AI 发送消息…"></textarea>
          <button id="sendBtn" class="send-btn">↑</button>
          <button id="stopBtn" class="send-btn hidden" style="background:#1f2937;">■</button>
        </div>
      </div>
    </div>

    <div id="debateView" class="view hidden">
      <div id="debateScroll" class="debate-scroll">
        <div id="debateInner" class="debate-scroll-inner">
          <div class="card">
            <h2>⚔️ 全自动辩论工作台</h2>
            <label>辩题</label>
            <textarea id="debateTopic" class="set-input" placeholder="输入辩题…" style="height:60px;"></textarea>
            
            <label>归档标签 (可选)</label>
            <input id="debateTags" class="set-input" placeholder="例如: 科创论文 / 经济">
            
            <div class="config-row">
              <div class="config-col"><label>选手 A 角色</label><input id="debateRoleA" class="set-input" value="正方"></div>
              <div class="config-col"><label>选手 B 角色</label><input id="debateRoleB" class="set-input" value="反方"></div>
            </div>

            <div class="config-row">
              <div class="config-col"><label>选手 A 模型</label><div id="ddA"></div></div>
              <div class="config-col"><label>选手 B 模型</label><div id="ddB"></div></div>
            </div>

            <div class="config-row">
              <div class="config-col"><label>选手 C 角色</label><input id="debateRoleC" class="set-input" value="补充视角"></div>
              <div class="config-col"><label>选手 D 角色</label><input id="debateRoleD" class="set-input" value="风险审查"></div>
            </div>

            <div class="config-row">
              <div class="config-col"><label>选手 C 模型（可选）</label><div id="ddC"></div></div>
              <div class="config-col"><label>选手 D 模型（可选）</label><div id="ddD"></div></div>
            </div>

            <p style="font-size:11.5px;color:var(--text-muted);margin-top:2px;">选「无（不参与）」则跳过该选手，至少保留两位。</p>

            <div class="config-row">
              <div class="config-col"><label>裁判模型</label><div id="ddJ"></div></div>
              <div class="config-col">
                <label>裁判风格模板</label>
                <select id="debateJudgeStyle" class="set-input">
                  <option value="academic">学术严谨版 (适合论文)</option>
                  <option value="decision">决策权衡版 (适合商业)</option>
                  <option value="review">审稿找茬版 (极严苛)</option>
                </select>
              </div>
            </div>

            <label>循环轮数 (及预估调用)</label>
            <div class="round-picker" id="roundPicker" style="display:flex; gap:5px; margin-bottom:10px;">
              <button data-r="1" style="flex:1; padding:8px; border:1px solid var(--border); border-radius:8px;">1轮</button>
              <button data-r="2" style="flex:1; padding:8px; border:1px solid var(--border); border-radius:8px;">2轮</button>
              <button data-r="3" style="flex:1; padding:8px; border:1px solid var(--border); border-radius:8px;">3轮</button>
            </div>
            <div class="api-estimate" id="apiEstimate">预计消耗：3 次 API 调用</div>

            <button id="debateStartBtn" class="primary-btn" style="margin-top:15px; width:100%; padding:12px; background:var(--accent); color:#fff; border-radius:12px; font-weight:bold;">🚀 开始辩论</button>
          </div>
          <div id="debateOutput"></div>
        </div>
      </div>
    </div>

    <div id="settingsView" class="view hidden">
      <div id="settingsScroll" class="settings-scroll">
        
        <section class="card set-card">
          <h3>📊 模型用量与额度统计</h3>
          <p>根据 API 返回的实际 usage 字段累计。免费模型显示本地估算剩余额度。</p>
          <div id="usageList" class="usage-list"></div>
        </section>

        <section class="card set-card">
          <h3>🎀 悬浮助手形象</h3>
          <div class="avatar-row">
            <div class="avatar-preview" id="avatarPreviewBox">🤖</div>
            <div>
              <button id="uploadAvatarBtn" class="set-btn">📷 上传图片</button>
              <button id="resetAvatarBtn" class="set-btn danger">恢复默认</button>
            </div>
          </div>
          <input type="file" id="avatarFile" accept="image/*" hidden>
          <p>上传图片会压缩至 256x256 的 Base64 并存入本地。</p>
        </section>

        <section class="card set-card">
          <h3>🌙 外观设置</h3>
          <div style="display:flex; justify-content:space-between; align-items:center; margin-top:10px;">
            <span>深色模式</span>
            <button id="toggleDarkMode" class="set-btn" style="margin:0;">切换主题</button>
          </div>
        </section>

        <section class="card set-card">
          <h3>🖼️ 聊天背景</h3>
          <p>上传图片作为全局背景，可调节不透明度（数值越低背景越淡）。</p>
          <div class="avatar-row">
            <div class="avatar-preview" id="bgPreviewBox"
                 style="border-radius:14px; width:80px; height:56px; font-size:24px;">🖼️</div>
            <div>
              <button id="uploadBgBtn" class="set-btn">📷 上传背景</button>
              <button id="resetBgBtn" class="set-btn danger">恢复默认</button>
            </div>
          </div>
          <input type="file" id="bgFile" accept="image/*" hidden>
          <div style="display:flex; align-items:center; gap:10px; margin-top:12px;">
            <span style="font-size:13px; white-space:nowrap;">不透明度</span>
            <input type="range" id="bgOpacityRange" min="0" max="100" step="1" value="100" style="flex:1;">
            <span id="bgOpacityVal" style="font-size:12px; color:var(--text-muted); width:42px; text-align:right;">100%</span>
          </div>
        </section>

        <section class="card set-card">
          <h3>✨ 悬浮助手名字</h3>
          <div style="display:flex; gap:10px;">
            <input id="assistantNameInput" class="set-input" type="text" placeholder="小助手" style="margin:0; flex:1;">
            <button id="saveAssistantNameBtn" class="set-btn" style="margin:0; white-space:nowrap;">保存</button>
          </div>
        </section>

        <section class="card set-card">
          <h3>🛠️ 高级设置</h3>
          <div style="display:flex; align-items:center; gap:10px; margin-top:10px;">
            <span style="font-size:14px;">自检重试次数:</span>
            <input type="number" id="retryCountInput" class="set-input" style="width:80px; margin:0; text-align:center;" min="1" max="10" value="3">
            <button id="saveRetryBtn" class="set-btn" style="margin:0;">保存</button>
          </div>
        </section>

        <section class="card set-card">
          <h3><span class="status-dot" id="dot-deepseek"></span> DeepSeek</h3>
          <input id="apiKeyInput" class="set-input" type="password" placeholder="sk-...">
          <button id="saveKeyBtn" class="set-btn">保存</button>
          <button class="set-btn test-btn" onclick="testKey('deepseek')">🔍 测试</button>
        </section>

        <section class="card set-card">
          <h3><span class="status-dot" id="dot-zhipu"></span> 智谱 AI</h3>
          <input id="keyZhipuInput" class="set-input" type="password" placeholder="API Key">
          <button id="saveKeyZhipuBtn" class="set-btn">保存</button>
          <button class="set-btn test-btn" onclick="testKey('zhipu')">🔍 测试</button>
        </section>

        <section class="card set-card">
          <h3><span class="status-dot" id="dot-qwen"></span> 通义千问</h3>
          <input id="keyQwenInput" class="set-input" type="password" placeholder="API Key">
          <button id="saveKeyQwenBtn" class="set-btn">保存</button>
          <button class="set-btn test-btn" onclick="testKey('qwen')">🔍 测试</button>
        </section>

        <section class="card set-card">
          <h3><span class="status-dot" id="dot-doubao"></span> 字节豆包 (自定义EP)</h3>
          <input id="keyDoubaoInput" class="set-input" type="password" placeholder="API Key">
          <input id="doubaoEndpointInput" class="set-input" type="text" placeholder="推理接入点 ID (ep-xxx)">
          <button id="saveKeyDoubaoBtn" class="set-btn">保存</button>
        </section>

        <section class="card set-card" style="background:var(--bg-color);">
          <h3 style="color:var(--accent);">📜 版本更新日志</h3>
          <div style="font-size:12px; line-height:1.8; color:var(--text-muted); margin-top:10px;">
            <b>v13.3.0 (当前版本)</b><br>
            - 新增：低档位 + 双倍检查时自动使用该厂商 Max 复核型号，并提示 token 消耗更快<br>
            - 新增：模型不支持细分档位时，面板底部与强度胶囊上给出提示<br>
            - 新增：双倍检查（自我核查）跑马灯开关、复核状态条<br>
            - 优化：非细分档位模型不再发送 reasoning_effort 参数<br>
            - 优化：缺 Key 提示内嵌「＋ 添加 API」快捷按钮，直达设置并高亮输入框<br>
            <br>
            <b>v13.2.0</b><br>
            - 修复：「新建对话」在空白会话中点击无效<br>
            - 修复：辩论模块缺少执行逻辑导致初始化中断<br>
            - 新增：能力胶囊（表格/严谨/标注/格式）<br>
            - 新增：辩论支持 4 位选手，C/D 可选「无」<br>
            - 新增：Markdown 表格 / 标题 / 列表 / 引用渲染
          </div>
        </section>

        <section class="card set-card">
          <h3>🗂️ 数据管理</h3>
          <button id="clearSessionsBtn" class="set-btn danger" style="margin-top:10px;">清空全部对话记录</button>
        </section>
      </div>
    </div>

    <nav class="tabbar">
      <button data-view="chat" class="active">💬 对话</button>
      <button data-view="debate">⚔️ 辩论</button>
      <button data-view="settings">⚙️ 设置</button>
    </nav>
  </div>
</div>

<div id="floatAssistant">
  <div class="assistant-bubble" id="assistantBubble">
    <div class="fold"></div>
    <div class="ab-head" id="assistantBubbleName">✨ 小助手</div>
    <div class="ab-body" id="assistantBubbleBody"></div>
    <div class="arrow"></div>
  </div>
  <div class="assistant-ring"></div>
  <div class="assistant-core" id="assistantAvatarCore">🤖</div>
</div>

<div id="toast"></div>		
<script>
(function () {
'use strict';

/* =====================================================
   === [粒子特效引擎] ===
   ===================================================== */
const canvas = document.getElementById('particleCanvas');
const ctx = canvas.getContext('2d');
let width, height, particles = [];
let particleColor = '#10b981';
let particleSpeed = 3;

function resizeCanvas() { width = canvas.width = window.innerWidth; height = canvas.height = window.innerHeight; }
window.addEventListener('resize', resizeCanvas);
resizeCanvas();

class Particle {
  constructor() { this.reset(); this.y = height + Math.random() * 100; }
  reset() {
    this.x = width / 2 + (Math.random() - 0.5) * width * 0.8;
    this.y = height + 10;
    this.vx = (Math.random() - 0.5) * 1.5;
    this.vy = -(Math.random() * 2 + 1) * particleSpeed;
    this.radius = Math.random() * 2 + 0.5;
    this.alpha = Math.random() * 0.5 + 0.2;
    this.life = 1;
  }
  update() {
    this.x += this.vx; this.y += this.vy;
    this.life -= 0.005;
    if (this.life <= 0 || this.y < -10) this.reset();
  }
  draw() {
    ctx.beginPath(); ctx.arc(this.x, this.y, this.radius, 0, Math.PI * 2);
    ctx.fillStyle = particleColor; ctx.globalAlpha = this.alpha * this.life;
    ctx.fill(); ctx.globalAlpha = 1;
  }
}
for (let i = 0; i < 60; i++) particles.push(new Particle());

function animateParticles() {
  ctx.clearRect(0, 0, width, height);
  particles.forEach(p => { p.update(); p.draw(); });
  requestAnimationFrame(animateParticles);
}
animateParticles();

/* =====================================================
   === [常量配置] ===
   ===================================================== */
const STRENGTH_MAP = {
  vlow: { label: '极低', color: '#3b82f6', speed: 1, effort: 'low' },
  low:  { label: '低',   color: '#0ea5e9', speed: 2, effort: 'low' },
  mid:  { label: '中',   color: '#10b981', speed: 3.5, effort: 'medium' },
  high: { label: '高',   color: '#f97316', speed: 5, effort: 'high' },
  ultra:{ label: 'Ultra',color: '#8b5cf6', speed: 8, effort: 'high' }
};
const STRENGTH_VALS = ['vlow', 'low', 'mid', 'high', 'ultra'];
let currentStrength = 'mid';
let strengthIndex = 2;

const API_CONFIG = {
  deepseek: { url: 'https://api.deepseek.com/chat/completions', keyLS: 'autoPro_key_deepseek', name: 'DeepSeek' },
  zhipu: { url: 'https://open.bigmodel.cn/api/paas/v4/chat/completions', keyLS: 'autoPro_key_zhipu', name: '智谱' },
  qwen: { url: 'https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions', keyLS: 'autoPro_key_qwen', name: '千问' },
  doubao: { url: 'https://ark.cn-beijing.volces.com/api/v3/chat/completions', keyLS: 'autoPro_key_doubao', name: '豆包' }
};

const MODELS = [
  { id: 'deepseek-v4-pro',  p: 'deepseek', name: 'V4 Pro',   isFree: false, temp: 0.7, freeLimit: 0, tiered: true },
  { id: 'deepseek-flash',   p: 'deepseek', name: 'V4 Flash', isFree: false, temp: 0.7, freeLimit: 0, tiered: true },
  { id: 'deepseek-reasoner',p: 'deepseek', name: 'R1',       isFree: true, temp: 0.5, freeLimit: 5000000, tiered: false },
  { id: 'deepseek-chat',    p: 'deepseek', name: 'V3',       isFree: true, temp: 0.7, freeLimit: 5000000, tiered: false },
  { id: 'zhipu:glm-4-flash',p: 'zhipu',    name: 'GLM-4-Flash', isFree: true, temp: 0.7, freeLimit: 10000000, tiered: false },
  { id: 'zhipu:glm-4-plus', p: 'zhipu',    name: 'GLM-4-Plus',  isFree: false, temp: 0.7, freeLimit: 0, tiered: false },
  { id: 'qwen:qwen-turbo',  p: 'qwen',     name: 'Qwen-Turbo', isFree: true, temp: 0.7, freeLimit: 5000000, tiered: false },
  { id: 'qwen:qwen-max',    p: 'qwen',     name: 'Qwen-Max',   isFree: false, temp: 0.7, freeLimit: 0, tiered: false },
  { id: 'doubao:default',   p: 'doubao',   name: '豆包',       isFree: false, temp: 0.7, freeLimit: 0, tiered: false }
];

const MAX_OF = {
  deepseek: 'deepseek-v4-pro',
  zhipu: 'zhipu:glm-4-plus',
  qwen: 'qwen:qwen-max',
  doubao: 'doubao:default'
};

const KEY_INPUT_MAP = {
  deepseek: 'apiKeyInput',
  zhipu: 'keyZhipuInput',
  qwen: 'keyQwenInput',
  doubao: 'keyDoubaoInput'
};

const JUDGE_TEMPLATES = {
  academic: '你是一名学术委员会主席。请严格审视各方论据，指出理论漏洞、逻辑谬误，并给出如何提升学术严谨性的修改建议。',
  decision: '你是一名企业战略顾问。请权衡各方观点的商业价值与落地风险，指出可行性上的优缺点，并给出务实的决策建议。',
  review: '你是一本顶刊的匿名审稿人。请极度挑剔、毫不留情地找茬，指出所有论证薄弱、数据缺失的地方，并给出严苛的修改意见。'
};

const CAPS = {
  table:    { label: '表格化输出', prompt: '涉及对比、数据、多方案取舍时，必须使用 Markdown 表格呈现，不要把对比写成大段文字。' },
  rigorous: { label: '严谨分析',   prompt: '先给出明确结论，再分点列出论据、数据与前提假设；主动指出不确定性、风险与反例。' },
  annotate: { label: '文中标注',   prompt: '关键结论后用「（依据：…）」的形式就地标注证据、来源或推导依据，让读者能追溯每条判断。' },
  format:   { label: '格式规范',   prompt: '统一使用标题、有序/无序列表与加粗小标题组织内容，层级清晰，段落简短。' }
};

const CHECK_SYS = [
  '你是一名极其严格的自检复核员。请对「初稿回答」进行二次核查：',
  '1) 事实、数据、引用是否准确；',
  '2) 逻辑链是否有跳步、循环论证或偷换概念；',
  '3) 计算与单位是否出错；',
  '4) 是否遗漏关键前提、反例或风险；',
  '5) 排版与格式是否规范（表格、分点、层级）。',
  '要求：直接输出修订后的【完整最终答案】（Markdown），不要写修改说明；若初稿无误，原样输出初稿。'
].join('\n');

/* =====================================================
   === [状态] ===
   ===================================================== */
let sessions = JSON.parse(localStorage.getItem('autoPro_sessions') || '[]');
let currentId = localStorage.getItem('autoPro_current');
let currentView = 'chat';
let chatModel = 'deepseek-v4-pro';
let streaming = false;
let chatAborter = null;
let debating = false;
let debateCfg = Object.assign(
  { a: 'deepseek-v4-pro', b: 'zhipu:glm-4-flash', c: 'none', d: 'none', j: 'deepseek-reasoner', rounds: 1 },
  JSON.parse(localStorage.getItem('autoPro_debateCfg') || '{}')
);
let usageStats = JSON.parse(localStorage.getItem('autoPro_usageStats') || '{}');
let enabledCaps = [];
try { enabledCaps = JSON.parse(localStorage.getItem('autoPro_caps') || '[]'); } catch (e) { enabledCaps = []; }
if (!Array.isArray(enabledCaps)) enabledCaps = [];
let selfCheckOn = localStorage.getItem('autoPro_selfCheck') === '1';

const $ = id => document.getElementById(id);
const getKey = p => (localStorage.getItem(API_CONFIG[p].keyLS) || '').trim();
const escapeHtml = s => String(s == null ? '' : s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
const modelById = id => MODELS.find(m => m.id === id) || MODELS[0];
const timeAgo = ts => { let d = new Date(ts), now = new Date(); if(d.toDateString()===now.toDateString()) return d.getHours()+':'+String(d.getMinutes()).padStart(2,'0'); return (d.getMonth()+1)+'/'+d.getDate(); };

function resolveModel(modelId) {
  let p = 'deepseek';
  if (modelId.indexOf('zhipu:') === 0) p = 'zhipu';
  else if (modelId.indexOf('qwen:') === 0) p = 'qwen';
  else if (modelId.indexOf('doubao:') === 0) p = 'doubao';
  let name = modelId.indexOf(':') >= 0 ? modelId.split(':')[1] : modelId;
  if (p === 'doubao') name = localStorage.getItem('autoPro_doubao_ep') || 'default';
  return { p: p, name: name, url: API_CONFIG[p].url, keyLS: API_CONFIG[p].keyLS };
}

/* =====================================================
   === [Toast] ===
   ===================================================== */
let toastTimer = null;

function hideToast() {
  const t = $('toast');
  if (!t) return;
  t.classList.remove('show', 'toast-has-action');
  t.style.pointerEvents = '';
}

function showToast(msg, action) {
  const t = $('toast');
  if (!t) return;
  t.innerHTML = '';
  const span = document.createElement('span');
  span.textContent = msg;
  t.appendChild(span);

  if (action && action.type === 'key') {
    const b = document.createElement('button');
    b.type = 'button';
    b.className = 'toast-action';
    b.textContent = '＋ 添加 ' + (API_CONFIG[action.provider] ? API_CONFIG[action.provider].name : '') + ' API';
    b.onclick = (e) => {
      e.stopPropagation();
      hideToast();
      gotoSettingsKey(action.provider);
    };
    t.appendChild(b);
    t.classList.add('toast-has-action');
    t.style.pointerEvents = 'auto';
  } else {
    t.classList.remove('toast-has-action');
    t.style.pointerEvents = '';
  }

  t.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(hideToast, (action && action.type === 'key') ? 8000 : 3500);
}

function gotoSettingsKey(provider) {
  switchView('settings');
  setTimeout(() => {
    const input = $(KEY_INPUT_MAP[provider] || 'apiKeyInput');
    if (!input) return;
    const card = input.closest('.set-card') || input;
    card.scrollIntoView({ behavior: 'smooth', block: 'center' });
    setTimeout(() => {
      try { input.focus({ preventScroll: true }); } catch (e) { input.focus(); }
      input.style.transition = 'box-shadow .25s, border-color .25s';
      input.style.boxShadow = '0 0 0 3px rgba(79,109,245,.45)';
      input.style.borderColor = 'var(--accent)';
      setTimeout(() => { input.style.boxShadow = ''; input.style.borderColor = ''; }, 1800);
    }, 430);
  }, 160);
}

/* =====================================================
   === [Markdown 渲染] ===
   ===================================================== */
function renderMarkdown(src) {
  let blocks = [];
  let text = String(src || '');
  text = text.replace(/```([\w-]*)\n?([\s\S]*?)```/g, (m, l, c) => {
    blocks.push('<pre><code>' + escapeHtml(c) + '</code></pre>');
    return '\u0000B' + (blocks.length - 1) + '\u0000';
  });

  const inline = s => escapeHtml(s)
    .replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>')
    .replace(/`([^`\n]+)`/g, '<code>$1</code>')
    .replace(/(^|[^*])\*([^*\n]+)\*/g, '$1<em>$2</em>');

  const splitRow = line => line.trim().replace(/^\|/, '').replace(/\|$/, '').split('|').map(c => c.trim());
  const lines = text.split('\n');
  const out = [];
  let i = 0;

  while (i < lines.length) {
    const line = lines[i];
    if (/^\s*$/.test(line)) { i++; continue; }
    if (/^\u0000B\d+\u0000\s*$/.test(line.trim())) { out.push(line.trim()); i++; continue; }

    if (line.indexOf('|') >= 0 && i + 1 < lines.length &&
        /^\s*\|?[\s:|-]+\|[\s:|-]*$/.test(lines[i + 1]) && lines[i + 1].indexOf('-') >= 0) {
      const head = splitRow(line); i += 2;
      const rows = [];
      while (i < lines.length && lines[i].indexOf('|') >= 0 && lines[i].trim()) { rows.push(splitRow(lines[i])); i++; }
      out.push('<div class="md-table-wrap"><table><thead><tr>' +
        head.map(h => '<th>' + inline(h) + '</th>').join('') +
        '</tr></thead><tbody>' +
        rows.map(r => '<tr>' + r.map(c => '<td>' + inline(c) + '</td>').join('') + '</tr>').join('') +
        '</tbody></table></div>');
      continue;
    }

    const hm = line.match(/^(#{1,6})\s+(.*)$/);
    if (hm) {
      const lv = Math.min(hm[1].length + 2, 6);
      out.push('<h' + lv + ' class="md-h">' + inline(hm[2]) + '</h' + lv + '>');
      i++; continue;
    }

    if (/^\s*([-*_])\1\1+\s*$/.test(line)) { out.push('<hr class="md-hr">'); i++; continue; }

    if (/^\s*>\s?/.test(line)) {
      const buf = [];
      while (i < lines.length && /^\s*>\s?/.test(lines[i])) { buf.push(lines[i].replace(/^\s*>\s?/, '')); i++; }
      out.push('<blockquote class="md-quote">' + buf.map(b => inline(b)).join('<br>') + '</blockquote>');
      continue;
    }

    if (/^\s*[-*+]\s+/.test(line) || /^\s*\d+[.)]\s+/.test(line)) {
      const ordered = /^\s*\d+[.)]\s+/.test(line);
      const items = [];
      while (i < lines.length && (/^\s*[-*+]\s+/.test(lines[i]) || /^\s*\d+[.)]\s+/.test(lines[i]))) {
        items.push(inline(lines[i].replace(/^\s*([-*+]|\d+[.)])\s+/, '')));
        i++;
      }
      const tag = ordered ? 'ol' : 'ul';
      out.push('<' + tag + ' class="md-list">' + items.map(t => '<li>' + t + '</li>').join('') + '</' + tag + '>');
      continue;
    }

    const buf = [];
    while (i < lines.length && lines[i].trim() &&
           !/^\s*(#{1,6}\s|>\s?|[-*+]\s|\d+[.)]\s)/.test(lines[i]) &&
           !/^\u0000B\d+\u0000/.test(lines[i].trim()) &&
           !(lines[i].indexOf('|') >= 0 && i + 1 < lines.length && /^\s*\|?[\s:|-]+\|[\s:|-]*$/.test(lines[i + 1]))) {
      buf.push(lines[i]); i++;
    }
    if (!buf.length) { buf.push(lines[i]); i++; }
    out.push('<p class="md-p">' + buf.map(b => inline(b)).join('<br>') + '</p>');
  }
  return out.join('').replace(/\u0000B(\d+)\u0000/g, (m, idx) => blocks[idx]);
}

/* =====================================================
   === [用量统计] ===
   ===================================================== */
function recordUsage(modelId, usage) {
  if (!usage) return;
  if (!usageStats[modelId]) usageStats[modelId] = { in: 0, out: 0, total: 0 };
  usageStats[modelId].in += usage.prompt_tokens || 0;
  usageStats[modelId].out += usage.completion_tokens || 0;
  usageStats[modelId].total += usage.total_tokens || 0;
  localStorage.setItem('autoPro_usageStats', JSON.stringify(usageStats));
  renderUsageList();
}

function renderUsageList() {
  let html = '';
  MODELS.forEach(m => {
    let s = usageStats[m.id] || { in: 0, out: 0, total: 0 };
    let tag = m.isFree ? '<span class="free-tag" style="font-size:9px;padding:1px 4px;margin-left:0;">🆓可用</span>' : '<span class="paid-tag" style="font-size:9px;padding:1px 4px;margin-left:0;">💰付费</span>';
    html += `<div class="usage-item">
      <div class="usage-top">
        <span class="usage-name">${m.name} ${tag}</span>
        <span class="usage-tokens">↑${s.in} ↓${s.out} · 合计 ${s.total}</span>
      </div>`;
    if (m.isFree && m.freeLimit > 0) {
      let remain = Math.max(0, m.freeLimit - s.total);
      let pct = (remain / m.freeLimit) * 100;
      let color = pct > 20 ? '#10b981' : '#ef4444';
      html += `<div class="quota-bar-wrap"><div class="quota-bar-fill" style="width: ${pct}%; background: ${color};"></div></div>
      <div class="quota-bar-text">本地预估免费额度：剩余约 ${remain.toLocaleString()} / ${m.freeLimit.toLocaleString()}</div>`;
    }
    html += `</div>`;
  });
  $('usageList').innerHTML = html;
}

/* =====================================================
   === [强度滑块 + 双倍检查 + 档位提示] ===
   ===================================================== */
const toggleBtn = $('strengthToggle');
const toggleText = $('toggleText');
const expandedBox = $('strengthExpanded');
const rangeInput = $('strengthRange');
const sliderFill = $('sliderFill');
const sliderThumb = $('sliderThumb');
const labels = document.querySelectorAll('.slider-labels span');
const strengthArrow = $('strengthArrow');

function setPanelOpen(open) {
  expandedBox.classList.toggle('open', open);
  strengthArrow.textContent = open ? '▼' : '▲';
}

function checkModelFor(modelId) {
  const base = modelById(modelId);
  if (selfCheckOn && strengthIndex <= 1) {
    const maxId = MAX_OF[base.p];
    if (maxId && maxId !== modelId) return { id: maxId, upgraded: true };
  }
  return { id: modelId, upgraded: false };
}

function refreshHints() {
  const m = modelById(chatModel);
  const tiered = !!m.tiered;
  const th = $('tierHint'), ch = $('checkHint'), tw = $('tierWarn'), sb = $('scBadge');

  if (th) {
    th.textContent = tiered
      ? '✓ 当前模型支持细分档位（会发送 reasoning_effort）'
      : '⚠️ 当前模型不支持细分档位，滑块仅调整语气与粒子特效';
    th.classList.toggle('warn', !tiered);
  }
  if (tw) tw.classList.toggle('show', !tiered);

  if (ch) {
    if (!selfCheckOn) {
      ch.textContent = '双倍检查未开启 · 单次生成，省 token';
      ch.classList.remove('warn');
    } else {
      const pick = checkModelFor(chatModel);
      const nm = modelById(pick.id).name;
      ch.textContent = pick.upgraded
        ? `⚡ 低档位已启用 Max 复核：${nm} · token 消耗明显加快`
        : `复核模型：${nm} · 消耗约 ×2`;
      ch.classList.toggle('warn', pick.upgraded);
    }
  }
  if (sb) sb.classList.toggle('show', selfCheckOn);
  $('selfCheckRow').classList.toggle('selfcheck-on', selfCheckOn);
}

function updateSliderUI(val) {
  const pct = (val / 4) * 100;
  sliderThumb.style.left = pct + '%';
  sliderFill.style.width = pct + '%';

  const key = STRENGTH_VALS[val];
  const cfg = STRENGTH_MAP[key];
  currentStrength = key;
  strengthIndex = val;

  particleColor = cfg.color;
  particleSpeed = cfg.speed;
  particles.forEach(p => { p.vy = -(Math.random() * 2 + 1) * particleSpeed; });

  toggleText.textContent = `⚡ ${cfg.label}`;
  sliderFill.style.background = cfg.color;
  sliderThumb.style.borderColor = cfg.color;
  labels.forEach((l, i) => l.classList.toggle('active', i === val));

  refreshHints();
  if (val === 4) showToast('⚡ Ultra 模式已开启');
}

rangeInput.addEventListener('input', (e) => { updateSliderUI(parseInt(e.target.value, 10)); });

toggleBtn.addEventListener('click', (e) => {
  e.stopPropagation();
  setPanelOpen(!expandedBox.classList.contains('open'));
});

const scSwitch = $('scSwitch');
function renderSelfSwitch() {
  scSwitch.dataset.on = selfCheckOn ? '1' : '0';
  scSwitch.setAttribute('aria-pressed', selfCheckOn ? 'true' : 'false');
  refreshHints();
}
scSwitch.addEventListener('click', (e) => {
  e.stopPropagation();
  selfCheckOn = !selfCheckOn;
  localStorage.setItem('autoPro_selfCheck', selfCheckOn ? '1' : '0');
  renderSelfSwitch();
  const pick = checkModelFor(chatModel);
  if (selfCheckOn && pick.upgraded) {
    showToast('⚡ 双倍检查已开启 · 低档位将用 ' + modelById(pick.id).name + ' 复核，token 消耗更快');
  } else {
    showToast(selfCheckOn ? '⚡ 双倍检查已开启：额度消耗约 ×2' : '已关闭双倍检查');
  }
});

document.addEventListener('pointerdown', (e) => {
  if (!e.target.closest('.strength-wrapper')) setPanelOpen(false);
});

/* =====================================================
   === [配置 / 头像 / 名字] ===
   ===================================================== */
let retryLimit = parseInt(localStorage.getItem('autoPro_retryCount') || '3', 10);
$('retryCountInput').value = retryLimit;
$('saveRetryBtn').onclick = () => {
  let v = parseInt($('retryCountInput').value, 10);
  if (isNaN(v) || v < 1 || v > 10) return showToast('请输入 1-10 之间的数字');
  retryLimit = v; localStorage.setItem('autoPro_retryCount', retryLimit); showToast('自检次数已保存');
};

const isDark = localStorage.getItem('autoPro_dark') === 'true';
if (isDark) document.body.classList.add('dark');
$('toggleDarkMode').onclick = () => {
  document.body.classList.toggle('dark');
  localStorage.setItem('autoPro_dark', document.body.classList.contains('dark'));
};

let assistantAvatarSrc = localStorage.getItem('autoPro_avatar') || '';
function applyAvatar() {
  const core = $('assistantAvatarCore');
  const preview = $('avatarPreviewBox');
  if (assistantAvatarSrc) {
    core.innerHTML = `<img src="${assistantAvatarSrc}" alt="avatar">`;
    preview.innerHTML = `<img src="${assistantAvatarSrc}" alt="preview">`;
  } else {
    core.innerHTML = '🤖';
    preview.innerHTML = '🤖';
  }
}
applyAvatar();

$('uploadAvatarBtn').onclick = () => $('avatarFile').click();
$('avatarFile').onchange = (e) => {
  const file = e.target.files[0]; if (!file) return;
  const reader = new FileReader();
  reader.onload = (ev) => {
    const img = new Image();
    img.onload = () => {
      const cvs = document.createElement('canvas');
      cvs.width = 256; cvs.height = 256;
      const c2 = cvs.getContext('2d');
      const min = Math.min(img.width, img.height);
      const sx = (img.width - min) / 2, sy = (img.height - min) / 2;
      c2.drawImage(img, sx, sy, min, min, 0, 0, 256, 256);
      assistantAvatarSrc = cvs.toDataURL('image/jpeg', 0.85);
      localStorage.setItem('autoPro_avatar', assistantAvatarSrc);
      applyAvatar();
      showToast('头像已更新');
    };
    img.src = ev.target.result;
  };
  reader.readAsDataURL(file);
  e.target.value = '';
};
$('resetAvatarBtn').onclick = () => {
  assistantAvatarSrc = '';
  localStorage.removeItem('autoPro_avatar');
  applyAvatar();
};

let assistantName = localStorage.getItem('autoPro_assistantName') || '小助手';
$('assistantBubbleName').textContent = `✨ ${assistantName}`;
$('assistantNameInput').value = assistantName;
$('saveAssistantNameBtn').onclick = () => {
  let v = $('assistantNameInput').value.trim();
  if (!v) return showToast('名字不能为空');
  assistantName = v; localStorage.setItem('autoPro_assistantName', v);
  $('assistantBubbleName').textContent = `✨ ${assistantName}`; showToast('名字已更新');
};

function checkProviderStatus() {
  for (let p in API_CONFIG) {
    let ok = !!getKey(p);
    let dot = $('dot-' + p);
    if (dot) dot.classList.toggle('ok', ok);
  }
}

/* =====================================================
   === [会话管理] ===
   ===================================================== */
function persistSessions() {
  localStorage.setItem('autoPro_sessions', JSON.stringify(sessions));
  localStorage.setItem('autoPro_current', currentId || '');
}

function renderSessions() {
  const list = $('sessionList'); list.innerHTML = '';
  if (!sessions.length) { list.innerHTML = '<div style="text-align:center;padding:20px;color:var(--text-muted);font-size:12px;">暂无对话</div>'; return; }
  sessions.forEach(s => {
    let el = document.createElement('div');
    el.className = 'sess-item' + (s.id === currentId ? ' active' : '');
    el.innerHTML = `<div style="flex:1; overflow:hidden;"><div class="sess-title">${escapeHtml(s.title)}${s.tags ? `<span class="sess-tag">${escapeHtml(s.tags)}</span>` : ''}</div><div style="font-size:10px;color:var(--text-muted);margin-top:2px;">${escapeHtml(modelById(s.model).name)} · ${timeAgo(s.ts)}</div></div><button class="sess-del">✕</button>`;
    el.onclick = e => { if (!e.target.closest('.sess-del')) openSession(s.id); };
    el.querySelector('.sess-del').onclick = e => { e.stopPropagation(); deleteSession(s.id); };
    list.appendChild(el);
  });
}

function deleteSession(id) {
  if (!confirm('删除这个对话？')) return;
  sessions = sessions.filter(s => s.id !== id);
  if (currentId === id) currentId = sessions.length ? sessions[0].id : null;
  persistSessions();
  renderSessions(); renderChat();
}

function openSession(id) {
  currentId = id; let s = sessions.find(x => x.id === id);
  if (s) { chatModel = s.model; refreshHints(); }
  localStorage.setItem('autoPro_current', id);
  renderSessions(); renderChat(); closeDrawer();
  if (currentView !== 'chat') switchView('chat');
}

function newSession() {
  sessions = sessions.filter(s => s.messages && s.messages.length > 0);
  const s = { id: Date.now().toString(36), title: '新对话', model: chatModel, messages: [], ts: Date.now() };
  sessions.unshift(s); currentId = s.id;
  persistSessions();
  renderSessions(); renderChat();
  if (currentView !== 'chat') switchView('chat');
  showToast('已新建对话');
  setTimeout(() => { try { $('chatInput').focus(); } catch (e) {} }, 60);
}

function renderChat() {
  const inner = $('chatInner'); inner.innerHTML = '';
  const s = sessions.find(x => x.id === currentId);
  if (!s || !s.messages.length) {
    inner.innerHTML = `<div style="text-align:center;padding:40px 20px;color:var(--text-muted);"><h2 style="font-size:22px;color:var(--text-color);margin-bottom:10px;">studio Ultra</h2><p>v13.3.0 旗舰版 · 全自动闭环</p><p style="font-size:12px;margin-top:10px;">输入框上方有「✨ 能力」与「⚡ 强度」两个胶囊</p></div>`;
    $('topbarTitle').textContent = '新对话'; return;
  }
  $('topbarTitle').textContent = s.title;
  s.messages.forEach(m => {
    let wrap = document.createElement('div'); wrap.className = 'msg ' + m.role;
    if (m.role === 'user') {
      wrap.innerHTML = `<div class="bubble">${escapeHtml(m.content).replace(/\n/g,'<br>')}</div>`;
    } else {
      const flag = m.checked ? '<span class="sc-flag">⚡ 双倍检查</span>' : '';
      wrap.innerHTML = `<div class="bubble"><div class="msg-model"><span style="width:6px;height:6px;border-radius:50%;background:var(--accent);"></span>${modelById(m.model).name}${flag}</div><div class="md">${renderMarkdown(m.content)}</div></div>`;
    }
    inner.appendChild(wrap);
  });
  $('chatScroll').scrollTop = $('chatScroll').scrollHeight;
}

function switchView(v) {
  currentView = v;
  $('chatView').classList.toggle('hidden', v !== 'chat');
  $('debateView').classList.toggle('hidden', v !== 'debate');
  $('settingsView').classList.toggle('hidden', v !== 'settings');
  document.querySelectorAll('.tabbar button').forEach(b => b.classList.toggle('active', b.dataset.view === v));
  $('navDebateBtn').classList.toggle('active', v === 'debate');
  $('navSettingsBtn').classList.toggle('active', v === 'settings');
  if (v === 'settings') { checkProviderStatus(); renderUsageList(); }
  if (v !== 'chat') $('apiWarningBar').classList.remove('show');
  closeDrawer();
}
window.switchView = switchView;

/* =====================================================
   === [下拉组件] ===
   ===================================================== */
function closeAllDropdowns() { document.querySelectorAll('.dd-menu.open').forEach(m => m.classList.remove('open')); }
document.addEventListener('pointerdown', e => { if (!e.target.closest('.dd')) closeAllDropdowns(); });

function createDropdown(container, initial, onChange, opts) {
  opts = opts || {};
  let wrap = document.createElement('div'); wrap.className = 'dd';
  let btn = document.createElement('button'); btn.className = 'dd-btn';
  let menu = document.createElement('div'); menu.className = 'dd-menu';
  let val = initial;

  function buildMenu() {
    menu.innerHTML = '';

    if (opts.allowNone) {
      let it = document.createElement('button');
      it.className = 'dd-item' + (val === 'none' ? ' active' : '');
      it.innerHTML = '<span>🚫 无（不参与）</span>';
      it.onclick = (e) => {
        e.stopPropagation();
        if (val !== 'none') { val = 'none'; onChange({ id: 'none' }); }
        sync(); closeAllDropdowns();
      };
      menu.appendChild(it);
      let sep = document.createElement('div');
      sep.style.cssText = 'height:1px;background:var(--border);margin:6px 8px;';
      menu.appendChild(sep);
    }

    let grouped = {};
    MODELS.forEach(m => { if (!grouped[m.p]) grouped[m.p] = []; grouped[m.p].push(m); });

    for (let p in grouped) {
      let info = API_CONFIG[p];
      let hasKey = !!getKey(p);
      let title = document.createElement('div'); title.className = 'dd-group-title';
      title.innerHTML = `<span class="g-dot ${hasKey?'ok':''}"></span> ${info.name}`
       menu.appendChild(title);

      grouped[p].forEach(m => {
        let it = document.createElement('button');
        it.className = 'dd-item' + (val === m.id ? ' active' : '') + (!hasKey ? ' disabled' : '');
        let tagHtml = m.isFree ? `<span class="free-tag">🆓可用</span>` : `<span class="paid-tag">💰付费</span>`;
        it.innerHTML = `<span>${m.name}</span>${tagHtml}`;
        it.onclick = (e) => {
          e.stopPropagation();
          if (!hasKey) {
            return showToast(`请先在设置中配置 ${info.name} Key`, { type: 'key', provider: p });
          }
          if (val !== m.id) { val = m.id; onChange(m); }
          sync(); closeAllDropdowns();
        };
        menu.appendChild(it);
      });
    }
  }

  function sync() {
    if (val === 'none') {
      btn.innerHTML = '<span>无</span><span class="free-tag" style="margin-left:6px;font-size:9px;background:#94a3b8">跳过</span>';
      return;
    }
    let cur = modelById(val);
    btn.innerHTML = `<span>${cur.name}</span><span class="free-tag" style="margin-left:6px;font-size:9px;background:${cur.isFree?'#10b981':'#f59e0b'}">${cur.isFree?'🆓':'💰'}</span>`;
  }

  btn.onclick = (e) => {
    e.stopPropagation();
    let willOpen = !menu.classList.contains('open');
    closeAllDropdowns();
    if (willOpen) { buildMenu(); menu.classList.add('open'); }
  };

  wrap.appendChild(btn); wrap.appendChild(menu); container.appendChild(wrap); sync();
  return { get: () => val, set: v => { val = v; sync(); } };
}

/* =====================================================
   === [悬浮助手] ===
   ===================================================== */
const floatAssistant = $('floatAssistant');
const assistantBubble = $('assistantBubble');
let dragState = null, edgeTimer = null;

function resetEdgeTimer() {
  clearTimeout(edgeTimer);
  edgeTimer = setTimeout(() => {
    let rect = floatAssistant.getBoundingClientRect();
    if (rect.left < 20) floatAssistant.classList.add('edge-left');
    else if (window.innerWidth - rect.right < 20) floatAssistant.classList.add('edge-right');
  }, 3000);
}

floatAssistant.style.left = (window.innerWidth - 76) + 'px';
floatAssistant.style.top = (window.innerHeight - 190) + 'px';
resetEdgeTimer();

floatAssistant.addEventListener('pointerdown', e => {
  clearTimeout(edgeTimer);
  floatAssistant.classList.remove('edge-left', 'edge-right');
  dragState = { id: e.pointerId, sx: e.clientX, sy: e.clientY, ox: floatAssistant.offsetLeft, oy: floatAssistant.offsetTop, moved: false };
  floatAssistant.classList.add('dragging');
  if (assistantBubble.classList.contains('open')) assistantBubble.classList.remove('open');
  try { floatAssistant.setPointerCapture(e.pointerId); } catch (err) {}
});

floatAssistant.addEventListener('pointermove', e => {
  if (!dragState || e.pointerId !== dragState.id) return;
  let dx = e.clientX - dragState.sx, dy = e.clientY - dragState.sy;
  if (Math.abs(dx) > 6 || Math.abs(dy) > 6) dragState.moved = true;
  if (dragState.moved) {
    floatAssistant.style.left = Math.min(Math.max(dragState.ox + dx, 0), window.innerWidth - 72) + 'px';
    floatAssistant.style.top = Math.min(Math.max(dragState.oy + dy, 0), window.innerHeight - 72) + 'px';
  }
});

floatAssistant.addEventListener('pointerup', e => {
  if (!dragState || e.pointerId !== dragState.id) return;
  let moved = dragState.moved; dragState = null; floatAssistant.classList.remove('dragging');
  if (moved) {
    let rect = floatAssistant.getBoundingClientRect();
    if (rect.left < 20) { floatAssistant.style.left = '-10px'; }
    else if (window.innerWidth - rect.right < 20) { floatAssistant.style.left = (window.innerWidth - 62) + 'px'; }
    resetEdgeTimer();
    return;
  }

  let willOpen = !assistantBubble.classList.contains('open');
  assistantBubble.classList.toggle('open', willOpen);
  if (willOpen) {
    floatAssistant.classList.remove('edge-left', 'edge-right');
    resetEdgeTimer();
    let rect = floatAssistant.getBoundingClientRect();
    assistantBubble.classList.toggle('below', rect.top < 240);
    assistantBubble.classList.toggle('align-left', rect.left < 180);
    updateAssistantBubble();
  }
});

document.addEventListener('pointerdown', e => {
  if (!floatAssistant.contains(e.target) && assistantBubble.classList.contains('open')) assistantBubble.classList.remove('open');
});

async function updateAssistantBubble() {
  let body = $('assistantBubbleBody');
  body.innerHTML = '正在查询各平台状态...';
  let html = '';

  for (let p in API_CONFIG) {
    let name = API_CONFIG[p].name;
    let hasKey = !!getKey(p);
    if (!hasKey) {
      html += `<div class="ab-row"><span>${name}</span><span style="color:#ef4444">未配置</span></div>`;
      continue;
    }
    if (p === 'deepseek') {
      try {
        let res = await fetch('https://api.deepseek.com/user/balance', { headers: { 'Authorization': 'Bearer ' + getKey(p) } });
        let d = await res.json();
        let bal = (d.is_available && d.balance_infos.length) ? `¥ ${d.balance_infos[0].total_balance}` : '0.00';
        html += `<div class="ab-row"><span>${name}</span><b>${bal}</b></div>`;
      } catch (e) {
        html += `<div class="ab-row"><span>${name}</span><span style="color:#ef4444">查询超时</span></div>`;
      }
    } else {
      html += `<div class="ab-row"><span>${name}</span><span style="color:#10b981">已激活</span></div>`;
    }
  }
  body.innerHTML = html;
}

/* =====================================================
   === [核心请求] ===
   ===================================================== */
async function streamCompletion(opts) {
  const modelId = opts.model;
  const info = resolveModel(modelId);
  const key = getKey(info.p);
  if (!key) throw new Error(`未配置 ${API_CONFIG[info.p].name} 的 Key`);

  const m = modelById(modelId);
  let maxRetries = retryLimit;
  let retryCount = 0;

  const payload = {
    model: info.name,
    messages: opts.messages,
    stream: true,
    temperature: m.temp || 0.7,
    stream_options: { include_usage: true }
  };
  if (m.tiered) payload.reasoning_effort = opts.effort || STRENGTH_MAP[currentStrength].effort;

  const fetchOpts = {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer ' + key },
    body: JSON.stringify(payload),
    signal: opts.signal
  };

  while (retryCount <= maxRetries) {
    try {
      let res = await fetch(info.url, fetchOpts);

      if (res.status === 429) {
        if (retryCount < maxRetries) {
          retryCount++;
          showToast(`限流 429，${retryCount * 2}秒后重试 (${retryCount}/${maxRetries})...`);
          await new Promise(r => setTimeout(r, 2000 * retryCount));
          continue;
        } else throw new Error('触发限流 429');
      }

      if (!res.ok) {
        let detail = '';
        try { let j = await res.json(); detail = j.error?.message || j.message || ''; } catch (e) {}
        throw new Error(detail ? `HTTP ${res.status}: ${detail}` : `HTTP ${res.status}`);
      }

      let reader = res.body.getReader();
      let decoder = new TextDecoder();
      let buf = '', full = '';
      let usageData = null;

      while (true) {
        let { done, value } = await reader.read();
        if (done) break;
        buf += decoder.decode(value, { stream: true });
        let idx;
        while ((idx = buf.indexOf('\n')) >= 0) {
          let line = buf.slice(0, idx).trim(); buf = buf.slice(idx + 1);
          if (line.indexOf('data:') === 0) {
            let data = line.slice(5).trim();
            if (data === '[DONE]') continue;
            try {
              let json = JSON.parse(data);
              if (json.usage) usageData = json.usage;
              let delta = json.choices?.[0]?.delta?.content || '';
              if (delta) { full += delta; opts.onDelta && opts.onDelta(delta, full); }
            } catch(e){}
          }
        }
      }

      if (usageData) recordUsage(modelId, usageData);
      if (opts.onUsage) opts.onUsage(usageData);
      return full;
    } catch (e) {
      if (e.name === 'AbortError') throw e;
      if (retryCount >= maxRetries) {
        if (e.message.includes('429')) throw new Error('限流严重，建议切换');
        if (e.name === 'TypeError') throw new Error('网络超时或跨域被拦截');
        throw e;
      }
      retryCount++;
      await new Promise(r => setTimeout(r, 2000));
    }
  }
}

/* =====================================================
   === [双倍检查] ===
   ===================================================== */
async function runSelfCheck(answer, history, mdEl, modelId, signal) {
  if (!selfCheckOn || !answer || answer.indexOf('⚠️') === 0) return { text: answer, checked: false };
  if (signal && signal.aborted) return { text: answer, checked: false };

  const pick = checkModelFor(modelId);
  const info = resolveModel(pick.id);
  if (!getKey(info.p)) return { text: answer, checked: false };

  const bubble = mdEl ? mdEl.closest('.bubble') : null;
  let status = null;
  if (bubble) {
    status = document.createElement('div');
    status.className = 'sc-status';
    status.textContent = '⚡ 双倍检查中…' + (pick.upgraded ? '（Max 复核）' : '');
    bubble.appendChild(status);
  }

  try {
    const cleanHistory = (history || []).filter(m => m.role !== 'system');
    const msgs = [{ role: 'system', content: CHECK_SYS }]
      .concat(cleanHistory)
      .concat([
        { role: 'assistant', content: answer },
        { role: 'user', content: '请复核上面的回答，直接输出修订后的完整最终答案。' }
      ]);

    const text = await streamCompletion({
      model: pick.id,
      messages: msgs,
      effort: 'high',
      signal: signal,
      onDelta: (d, full) => { if (mdEl) mdEl.innerHTML = renderMarkdown(full); }
    });

    if (!text || !text.trim()) throw new Error('空响应');
    if (mdEl) mdEl.innerHTML = renderMarkdown(text);

    if (bubble) {
      const modelLine = bubble.querySelector('.msg-model');
      if (modelLine && !modelLine.querySelector('.sc-flag')) {
        const flag = document.createElement('span');
        flag.className = 'sc-flag';
        flag.textContent = pick.upgraded ? '⚡ 双倍检查 · Max' : '⚡ 双倍检查';
        modelLine.appendChild(flag);
      }
    }
    if (status) {
      status.textContent = '✅ 已完成双倍检查';
      status.classList.add('done');
      setTimeout(() => status.remove(), 2600);
    }
    return { text: text, checked: true };
  } catch (e) {
    if (status) {
      status.textContent = (e.name === 'AbortError') ? '已中止复核' : '⚠️ 复核失败，已保留原答案';
      status.classList.add('fail');
      setTimeout(() => status.remove(), 3200);
    }
    return { text: answer, checked: false };
  }
}

/* =====================================================
   === [发送消息] ===
   ===================================================== */
async function sendMessage() {
  let text = $('chatInput').value.trim(); if (!text || streaming) return;

  const base = modelById(chatModel);
  if (!getKey(base.p)) {
    $('apiWarnText').textContent = '当前模型未配置 ' + API_CONFIG[base.p].name + ' API';
    $('apiWarnLink').textContent = '去添加';
    $('apiWarningBar').classList.add('show');
    showToast('当前模型未配置 ' + API_CONFIG[base.p].name + ' API', { type: 'key', provider: base.p });
    setTimeout(() => $('apiWarningBar').classList.remove('show'), 6000);
    return;
  }

  let s = sessions.find(x => x.id === currentId);
  if (!s) { s = { id: Date.now().toString(36), title: text.slice(0, 10), model: chatModel, messages: [], ts: Date.now() }; sessions.unshift(s); currentId = s.id; }
  if (s.messages.length === 0) s.title = text.slice(0, 14) || '新对话';
  s.ts = Date.now();
  s.messages.push({ role: 'user', content: text });
  let aiMsg = { role: 'assistant', content: '', model: chatModel, checked: false };
  s.messages.push(aiMsg);
  persistSessions();

  $('chatInput').value = ''; $('chatInput').style.height = 'auto';
  streaming = true; $('sendBtn').classList.add('hidden'); $('stopBtn').classList.remove('hidden');
  renderChat(); renderSessions();

  let mdEl = $('chatInner').querySelector('.msg.assistant:last-child .md');
  let history = s.messages.filter(m => m !== aiMsg).map(m => ({ role: m.role, content: m.content }));
  const sys = buildCapSystem();
  if (sys) history = [{ role: 'system', content: sys }].concat(history);

  let full = '';
  chatAborter = new AbortController();

  try {
    await streamCompletion({
      messages: history, model: chatModel, signal: chatAborter.signal,
      onDelta: (d, f) => {
        full = f;
        if (mdEl) mdEl.innerHTML = renderMarkdown(full);
        const sc = $('chatScroll');
        if (sc.scrollHeight - sc.scrollTop - sc.clientHeight < 100) sc.scrollTop = sc.scrollHeight;
      }
    });

    let out = full;
    if (!chatAborter.signal.aborted) {
      const res = await runSelfCheck(full, history, mdEl, chatModel, chatAborter.signal);
      out = res.text;
      aiMsg.checked = res.checked;
    }
    aiMsg.content = out;
  } catch (e) {
    aiMsg.content = `⚠️ 请求异常：${e.message}`;
    if (mdEl) mdEl.innerHTML = `<div style="color:#ef4444">${escapeHtml(aiMsg.content)}</div>`;
  } finally {
    streaming = false; $('sendBtn').classList.remove('hidden'); $('stopBtn').classList.add('hidden');
    persistSessions();
  }
}

/* =====================================================
   === [API 测试] ===
   ===================================================== */
async function testKey(p) {
  let key = getKey(p);
  if (!key) return showToast('请先填写并保存 Key', { type: 'key', provider: p });
  showToast('正在测试连通性...');

  let testModel = 'deepseek-chat';
  if (p === 'zhipu') testModel = 'glm-4-flash';
  if (p === 'qwen') testModel = 'qwen-turbo';
  if (p === 'doubao') testModel = localStorage.getItem('autoPro_doubao_ep') || 'default';

  try {
    let res = await fetch(API_CONFIG[p].url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer ' + key },
      body: JSON.stringify({ model: testModel, messages: [{ role: 'user', content: 'Hi' }], max_tokens: 1 })
    });

    if (!res.ok) {
      let detail = '';
      try { let j = await res.json(); detail = j.error?.message || j.message || ''; } catch (e) {}
      if (res.status === 401 || res.status === 403) throw new Error(detail || '认证失败：Key 无效');
      if (res.status === 402) throw new Error('余额不足');
      if (res.status === 429) throw new Error('连通，但触发限流');
      throw new Error(detail ? `HTTP ${res.status}: ${detail}` : `HTTP ${res.status}`);
    }
    showToast('✅ Key 有效，测试通过！');
  } catch (e) { showToast(`❌ 测试失败: ${e.message}`); }
}
window.testKey = testKey;

/* =====================================================
   === [能力胶囊] ===
   ===================================================== */
function buildCapSystem() {
  const list = enabledCaps.map(k => CAPS[k]).filter(Boolean);
  if (!list.length) return '';
  return '【输出规范 · 必须严格遵守】\n' + list.map((c, i) => `${i + 1}. ${c.prompt}`).join('\n');
}

const capToggle = $('capToggle'), capPanel = $('capPanel');
function renderCaps() {
  document.querySelectorAll('.cap-item').forEach(el => {
    el.classList.toggle('on', enabledCaps.indexOf(el.dataset.cap) >= 0);
  });
  const n = enabledCaps.length;
  $('capCount').textContent = n;
  $('capCount').classList.toggle('hidden', n === 0);
  capToggle.classList.toggle('has-on', n > 0);
}
capToggle.onclick = (e) => {
  e.stopPropagation();
  const open = capPanel.classList.toggle('open');
  $('capArrow').textContent = open ? '▼' : '▲';
  if (open) setPanelOpen(false);
};
document.querySelectorAll('.cap-item').forEach(it => {
  it.onclick = () => {
    const k = it.dataset.cap;
    const i = enabledCaps.indexOf(k);
    if (i >= 0) enabledCaps.splice(i, 1); else enabledCaps.push(k);
    localStorage.setItem('autoPro_caps', JSON.stringify(enabledCaps));
    renderCaps();
  };
});
document.addEventListener('pointerdown', e => {
  if (!e.target.closest('.cap-wrapper')) {
    capPanel.classList.remove('open');
    $('capArrow').textContent = '▲';
  }
});
renderCaps();
/* =====================================================
   === [辩论引擎] ===
   ===================================================== */
function updateEstimate() {
  const n = ['a', 'b', 'c', 'd'].filter(k => debateCfg[k] && debateCfg[k] !== 'none').length;
  const calls = n * (debateCfg.rounds || 1) + 1;
  const el = $('apiEstimate');
  if (el) el.textContent = `预计消耗：${n} 位选手 × ${debateCfg.rounds || 1} 轮 + 1 次裁判 = ${calls} 次 API 调用`;
}

function debateRoundCard(round, list) {
  const card = document.createElement('div');
  card.className = 'debate-card';
  card.innerHTML = `<div class="round-head"><span class="round-title">第 ${round} 轮</span><span class="round-tag">${list.length} 位选手</span></div>`;
  list.forEach(d => {
    const ans = document.createElement('div');
    ans.className = 'ans';
    ans.innerHTML = `<div class="ans-head"><span>${escapeHtml(d.role)}</span><span>${escapeHtml(modelById(d.model).name)}</span></div><div class="ans-body md" data-key="${d.key}">…</div>`;
    card.appendChild(ans);
  });
  return card;
}

async function startDebate() {
  if (debating) return;
  const topic = $('debateTopic').value.trim();
  if (!topic) return showToast('请先输入辩题');

  const roles = {
    a: ($('debateRoleA').value.trim() || '正方'),
    b: ($('debateRoleB').value.trim() || '反方'),
    c: ($('debateRoleC').value.trim() || '补充视角'),
    d: ($('debateRoleD').value.trim() || '风险审查')
  };
  const list = ['a', 'b', 'c', 'd']
    .map(k => ({ key: k, role: roles[k], model: debateCfg[k] }))
    .filter(x => x.model && x.model !== 'none');

  if (list.length < 2) return showToast('至少需要两位选手参与');

  for (const d of list) {
    const mm = modelById(d.model);
    if (!getKey(mm.p)) return showToast(`${mm.name} 尚未配置 Key`, { type: 'key', provider: mm.p });
  }
  if (!debateCfg.j || debateCfg.j === 'none') return showToast('请先选择裁判模型');
  const jm = modelById(debateCfg.j);
  if (!getKey(jm.p)) return showToast(`裁判模型 ${jm.name} 尚未配置 Key`, { type: 'key', provider: jm.p });

  debating = true;
  const startBtn = $('debateStartBtn');
  startBtn.disabled = true; startBtn.style.opacity = '.6'; startBtn.textContent = '⏳ 辩论进行中…';

  const out = $('debateOutput'); out.innerHTML = '';
  const styleKey = $('debateJudgeStyle').value;
  const stylePrompt = JUDGE_TEMPLATES[styleKey] || JUDGE_TEMPLATES.academic;
  const styleName = { academic: '学术严谨版', decision: '决策权衡版', review: '审稿找茬版' }[styleKey] || '学术严谨版';
  const transcript = [];

  try {
    for (let r = 1; r <= debateCfg.rounds; r++) {
      const card = debateRoundCard(r, list);
      out.appendChild(card);
      card.scrollIntoView({ behavior: 'smooth', block: 'start' });

      const boxes = {};
      card.querySelectorAll('.ans-body').forEach(el => { boxes[el.dataset.key] = el; });

      const results = await Promise.all(list.map(async d => {
        const prev = transcript.length ? `\n\n【此前发言记录】\n${transcript.join('\n')}` : '';
        const prompt = `辩题：${topic}\n你的角色：${d.role}\n这是第 ${r} 轮交锋。\n请用 3-5 个要点陈述你的立场与论证，指出对手最薄弱之处，控制在 400 字以内，使用 Markdown 排版。${prev}`;
        try {
          const text = await streamCompletion({
            model: d.model,
            messages: [{ role: 'user', content: prompt }],
            onDelta: (delta, full) => { if (boxes[d.key]) boxes[d.key].innerHTML = renderMarkdown(full); }
          });
          if (boxes[d.key]) boxes[d.key].innerHTML = renderMarkdown(text);
          return { d, text };
        } catch (e) {
          if (boxes[d.key]) boxes[d.key].innerHTML = `<span style="color:#ef4444">⚠️ ${escapeHtml(e.message)}</span>`;
          return { d, text: `（本轮请求失败：${e.message}）` };
        }
      }));

      results.forEach(({ d, text }) => transcript.push(`[${d.role} · 第${r}轮] ${text}`));
    }

    const fusion = document.createElement('div');
    fusion.className = 'fusion-card';
    fusion.innerHTML = `
      <div class="fusion-head">🏆 最终裁决</div>
      <div class="fusion-meta">${escapeHtml(jm.name)} · ${styleName} · ${list.length} 位选手 × ${debateCfg.rounds} 轮</div>
      <div class="fusion-body md" id="fusionBody">正在汇总…</div>
      <div class="fusion-actions">
        <button class="fusion-btn" id="copyFusionBtn">📋 复制结论</button>
        <button class="fusion-btn" id="saveFusionBtn" style="background:linear-gradient(135deg,#fff,#e6e6e6);">💾 存入对话</button>
      </div>`;
    out.appendChild(fusion);
    fusion.scrollIntoView({ behavior: 'smooth', block: 'start' });

    const judgePrompt = `你是本场辩论的裁判。\n辩题：${topic}\n\n【裁判要求】\n${stylePrompt}\n\n【辩论全文】\n${transcript.join('\n\n')}\n\n请严格按以下结构用 Markdown 输出：\n1. 一句话裁决（哪一方更有说服力，并给出理由）\n2. 各方核心论点摘要（必须使用 Markdown 表格：列 = 选手 / 核心主张 / 最强论据 / 主要弱点）\n3. 关键分歧与胜负手\n4. 仍存在的漏洞与风险\n5. 给决策者的最终建议`;

    let judgeText = '';
    try {
      judgeText = await streamCompletion({
        model: debateCfg.j,
        messages: [{ role: 'user', content: judgePrompt }],
        onDelta: (delta, full) => { const el = $('fusionBody'); if (el) el.innerHTML = renderMarkdown(full); }
      });
      $('fusionBody').innerHTML = renderMarkdown(judgeText);
    } catch (e) {
      judgeText = `⚠️ 裁判请求失败：${e.message}`;
      $('fusionBody').innerHTML = `<span style="color:#fca5a5">${escapeHtml(judgeText)}</span>`;
    }

    $('copyFusionBtn').onclick = () => {
      if (navigator.clipboard) navigator.clipboard.writeText(judgeText).then(() => showToast('已复制裁决'), () => showToast('复制失败'));
      else showToast('当前环境不支持复制');
    };
    $('saveFusionBtn').onclick = () => {
      const tags = $('debateTags').value.trim();
      const s2 = {
        id: Date.now().toString(36),
        title: topic.slice(0, 16),
        model: debateCfg.j,
        tags: tags,
        messages: [
          { role: 'user', content: `【辩题】${topic}` },
          { role: 'assistant', content: judgeText, model: debateCfg.j }
        ],
        ts: Date.now()
      };
      sessions.unshift(s2); currentId = s2.id; persistSessions();
      renderSessions(); renderChat(); switchView('chat');
      showToast('裁决已存入对话');
    };
  } catch (e) {
    showToast('辩论异常：' + e.message);
  } finally {
    debating = false;
    startBtn.disabled = false; startBtn.style.opacity = '1'; startBtn.textContent = '🚀 开始辩论';
  }
}

/* =====================================================
   === [事件绑定与初始化] ===
   ===================================================== */
function closeDrawer() { $('sidebar').classList.remove('open'); $('overlay').classList.remove('show'); }
$('menuBtn').onclick = () => { $('sidebar').classList.add('open'); $('overlay').classList.add('show'); };
$('overlay').onclick = closeDrawer;
$('newChatSideBtn').onclick = newSession;
$('newChatBtn').onclick = newSession;
$('navDebateBtn').onclick = () => switchView('debate');
$('navSettingsBtn').onclick = () => switchView('settings');
document.querySelectorAll('.tabbar button').forEach(b => b.onclick = () => switchView(b.dataset.view));

$('sendBtn').onclick = sendMessage;
$('stopBtn').onclick = () => { if (chatAborter) chatAborter.abort(); };
$('chatInput').oninput = function () { this.style.height = 'auto'; this.style.height = Math.min(this.scrollHeight, 140) + 'px'; };
$('chatInput').addEventListener('keydown', e => {
  if (e.key === 'Enter' && !e.shiftKey && window.innerWidth > 767) { e.preventDefault(); sendMessage(); }
});

$('apiWarnLink').onclick = () => gotoSettingsKey(modelById(chatModel).p);

$('chatScroll').addEventListener('scroll', () => {
  const sc = $('chatScroll');
  const nearBottom = sc.scrollHeight - sc.scrollTop - sc.clientHeight < 120;
  $('downBtn').classList.toggle('show', !nearBottom);
});
$('downBtn').onclick = () => $('chatScroll').scrollTo({ top: $('chatScroll').scrollHeight, behavior: 'smooth' });

/* 轮数选择 */
document.querySelectorAll('#roundPicker button').forEach(b => b.onclick = () => {
  debateCfg.rounds = Number(b.dataset.r);
  document.querySelectorAll('#roundPicker button').forEach(x => { x.style.background = 'transparent'; x.style.color = 'var(--text-color)'; x.style.borderColor = 'var(--border)'; });
  b.style.background = 'rgba(79,109,245,.1)';
  b.style.color = 'var(--accent)';
  b.style.borderColor = 'rgba(79,109,245,.4)';
  localStorage.setItem('autoPro_debateCfg', JSON.stringify(debateCfg));
  updateEstimate();
});
const activeRoundBtn = document.querySelector(`#roundPicker button[data-r="${debateCfg.rounds}"]`) || document.querySelector('#roundPicker button[data-r="1"]');
if (activeRoundBtn) activeRoundBtn.click();

/* Key 保存 */
$('saveKeyBtn').onclick = () => { localStorage.setItem('autoPro_key_deepseek', $('apiKeyInput').value.trim()); checkProviderStatus(); showToast('已保存'); };
$('saveKeyZhipuBtn').onclick = () => { localStorage.setItem('autoPro_key_zhipu', $('keyZhipuInput').value.trim()); checkProviderStatus(); showToast('已保存'); };
$('saveKeyQwenBtn').onclick = () => { localStorage.setItem('autoPro_key_qwen', $('keyQwenInput').value.trim()); checkProviderStatus(); showToast('已保存'); };
$('saveKeyDoubaoBtn').onclick = () => { localStorage.setItem('autoPro_key_doubao', $('keyDoubaoInput').value.trim()); localStorage.setItem('autoPro_doubao_ep', $('doubaoEndpointInput').value.trim()); checkProviderStatus(); showToast('已保存'); };

/* 下拉初始化 */
createDropdown($('chatModelDD'), chatModel, m => { chatModel = m.id; refreshHints(); });
createDropdown($('ddA'), debateCfg.a, m => { debateCfg.a = m.id; localStorage.setItem('autoPro_debateCfg', JSON.stringify(debateCfg)); updateEstimate(); });
createDropdown($('ddB'), debateCfg.b, m => { debateCfg.b = m.id; localStorage.setItem('autoPro_debateCfg', JSON.stringify(debateCfg)); updateEstimate(); });
createDropdown($('ddC'), debateCfg.c, m => { debateCfg.c = m.id; localStorage.setItem('autoPro_debateCfg', JSON.stringify(debateCfg)); updateEstimate(); }, { allowNone: true });
createDropdown($('ddD'), debateCfg.d, m => { debateCfg.d = m.id; localStorage.setItem('autoPro_debateCfg', JSON.stringify(debateCfg)); updateEstimate(); }, { allowNone: true });
createDropdown($('ddJ'), debateCfg.j, m => { debateCfg.j = m.id; localStorage.setItem('autoPro_debateCfg', JSON.stringify(debateCfg)); updateEstimate(); });

$('debateStartBtn').onclick = startDebate;
$('clearSessionsBtn').onclick = () => { if (confirm('确定清空所有对话？')) { sessions = []; currentId = null; persistSessions(); renderSessions(); renderChat(); } };

$('debateJudgeStyle').onchange = () => localStorage.setItem('autoPro_judgeStyle', $('debateJudgeStyle').value);
const savedStyle = localStorage.getItem('autoPro_judgeStyle');
if (savedStyle) $('debateJudgeStyle').value = savedStyle;

$('apiKeyInput').value = getKey('deepseek');
$('keyZhipuInput').value = getKey('zhipu');
$('keyQwenInput').value = getKey('qwen');
$('keyDoubaoInput').value = getKey('doubao');
$('doubaoEndpointInput').value = localStorage.getItem('autoPro_doubao_ep') || '';

/* =====================================================
   === [自定义背景] ===
   ===================================================== */
let bgImageSrc = localStorage.getItem('autoPro_bgImage') || '';
let bgOpacity  = parseInt(localStorage.getItem('autoPro_bgOpacity') || '100', 10);
if (isNaN(bgOpacity)) bgOpacity = 100;

function applyBackground() {
  const bg = $('customBg');
  const preview = $('bgPreviewBox');
  if (!bg) return;
  if (bgImageSrc) {
    bg.style.backgroundImage = 'url("' + bgImageSrc + '")';
    bg.style.opacity = (bgOpacity / 100).toString();
    bg.classList.add('active');
    if (preview) { preview.style.padding = '0'; preview.innerHTML = `<img src="${bgImageSrc}" alt="">`; }
  } else {
    bg.style.backgroundImage = '';
    bg.classList.remove('active');
    if (preview) { preview.style.padding = ''; preview.innerHTML = '🖼️'; }
  }
  const r = $('bgOpacityRange'); if (r) r.value = bgOpacity;
  const v = $('bgOpacityVal');   if (v) v.textContent = bgOpacity + '%';
}

$('uploadBgBtn').onclick = () => $('bgFile').click();
$('bgFile').onchange = (e) => {
  const file = e.target.files[0]; if (!file) return;
  const reader = new FileReader();
  reader.onload = (ev) => {
    const img = new Image();
    img.onload = () => {
      const maxSide = 1920;
      let w = img.width, h = img.height;
      if (Math.max(w, h) > maxSide) {
        const s = maxSide / Math.max(w, h);
        w = Math.round(w * s); h = Math.round(h * s);
      }
      const cvs = document.createElement('canvas');
      cvs.width = w; cvs.height = h;
      cvs.getContext('2d').drawImage(img, 0, 0, w, h);
      try {
        bgImageSrc = cvs.toDataURL('image/jpeg', 0.82);
        localStorage.setItem('autoPro_bgImage', bgImageSrc);
        applyBackground();
        showToast('背景已更新');
      } catch (err) {
        showToast('图片过大，保存失败，请换一张更小的');
      }
    };
    img.src = ev.target.result;
  };
  reader.readAsDataURL(file);
  e.target.value = '';
};

$('resetBgBtn').onclick = () => {
  bgImageSrc = '';
  localStorage.removeItem('autoPro_bgImage');
  applyBackground();
  showToast('已恢复默认背景');
};

$('bgOpacityRange').oninput = (e) => {
  bgOpacity = parseInt(e.target.value, 10);
  localStorage.setItem('autoPro_bgOpacity', bgOpacity);
  applyBackground();
};

/* 初始化 */
checkProviderStatus();
if (!currentId || !sessions.find(x => x.id === currentId)) currentId = sessions.length ? sessions[0].id : null;
updateSliderUI(2);
renderSelfSwitch();
updateEstimate();
renderUsageList(); renderSessions(); renderChat(); switchView('chat');
renderCaps();
refreshHints();

/* 初始化应用背景 */
applyBackground();

})();
</script>
</body>
</html>
