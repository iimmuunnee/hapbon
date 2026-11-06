<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<!-- 보안 정책: 이 페이지는 어떤 서버와도 통신할 수 없고, 외부 파일을 하나도 불러오지 않아요 -->
<meta http-equiv="Content-Security-Policy" content="default-src 'none'; script-src 'unsafe-inline' blob:; worker-src blob:; style-src 'unsafe-inline'; img-src data: blob:; font-src data: blob:; connect-src 'none'; media-src 'none'; object-src 'none'; frame-src 'none'; child-src blob:; form-action 'none'; base-uri 'none'; manifest-src 'none'">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#F2F4F6">
<meta name="color-scheme" content="light dark">
<script>
  (function(){ var t; try { t = localStorage.getItem('hapbon-theme'); } catch(e){}
    if (t !== 'light' && t !== 'dark') t = matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
    document.documentElement.dataset.theme = t; })();
</script>
<title>합본 - PDF 합치기</title>
<meta name="description" content="PDF와 사진을 원하는 순서로 한 파일로 합쳐요. 업로드 없이 내 기기 안에서만 처리해요.">
<meta property="og:type" content="website">
<meta property="og:title" content="합본 - PDF 합치기">
<meta property="og:description" content="PDF와 사진을 원하는 순서로 한 파일로. 업로드 없이 내 기기 안에서만, 설치 없이 무료로.">
<meta property="og:url" content="https://iimmuunnee.github.io/hapbon/">
<meta property="og:image" content="https://iimmuunnee.github.io/hapbon/docs/images/social.png">
<meta property="og:image:width" content="1280">
<meta property="og:image:height" content="640">
<meta name="twitter:card" content="summary_large_image">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'%3E%3Crect x='9' y='4' width='18' height='23' rx='3' fill='%23B9D7FC'/%3E%3Crect x='5' y='7' width='18' height='23' rx='3' fill='%233182F6'/%3E%3Cpath d='M10 14h8M10 19h8M10 24h5' stroke='white' stroke-width='2' stroke-linecap='round'/%3E%3C/svg%3E">
<style>
  :root{
    --bg:#F2F4F6; --card:#FFFFFF; --ink:#191F28; --sub:#4E5968; --muted:#8B95A1; --line:#E5E8EB; --fill:#F9FAFB;
    --primary:#3182F6; --primary-press:#1B64DA; --primary-soft:#E8F3FF; --danger:#F04452;
    --elev:#FFFFFF; --danger-soft:#FFF5F5; --danger-soft2:#FFE3E3; --shadow:rgba(0,27,55,.08); --shadow2:rgba(0,27,55,.18);
    --badge-bg:#191F28; --badge-fg:#FFFFFF; --paper:#FFFFFF; --paper2:#FFFFFF; --placeholder:#B0B8C1; --warn:#B25E09;
    --bar-bg:rgba(255,255,255,.96); --toast:#333D4B; --sk1:#EEF0F3; --sk2:#F7F8FA; --track:#C5CCD3; --track-h:#8B95A1;
    --radius:16px; --ease:cubic-bezier(.2,.8,.2,1);
  }
  *{box-sizing:border-box}
  html,body{margin:0;height:100%}
  body{background:var(--bg);color:var(--ink);font-family:Pretendard,"Pretendard Variable",-apple-system,BlinkMacSystemFont,"Apple SD Gothic Neo","Malgun Gothic","Noto Sans KR",sans-serif;-webkit-font-smoothing:antialiased;letter-spacing:-0.01em}
  button{font:inherit;color:inherit;cursor:pointer;border:0;background:none}
  button:disabled{cursor:default}
  .wrap{max-width:1080px;margin:0 auto;padding:40px 24px 140px}

  /* header */
  header{display:flex;align-items:flex-end;justify-content:space-between;gap:16px;margin-bottom:24px}
  h1{font-size:26px;font-weight:700;margin:0 0 6px;display:flex;align-items:baseline;gap:10px}
  .h1-sub{font-size:15px;font-weight:600;color:var(--muted)}
  .lead{margin:0;color:var(--sub);font-size:15px;display:flex;align-items:center;gap:6px;word-break:keep-all}
  .lead svg{color:var(--primary);flex:none}
  .btn{height:44px;padding:0 18px;border-radius:12px;font-size:15px;font-weight:600;display:inline-flex;align-items:center;gap:6px;white-space:nowrap;flex:none;transition:background .15s var(--ease),transform .1s var(--ease)}
  .btn:active:not(:disabled){transform:scale(.97)}
  .btn-secondary{background:var(--primary-soft);color:var(--primary)}
  .btn-secondary:hover{background:var(--primary-soft2,#D6E9FF)}
  .btn-primary{background:var(--primary);color:#fff;min-width:148px;justify-content:center}
  .btn-primary:hover:not(:disabled){background:var(--primary-press)}
  .btn-primary:disabled{background:var(--primary-dis,#B9D7FC)}

  /* empty state */
  .empty{background:var(--card);border-radius:24px;padding:72px 24px;text-align:center;border:2px dashed transparent;transition:border-color .15s var(--ease),background .15s var(--ease);cursor:pointer}
  .empty:hover{border-color:var(--line)}
  .empty .ico{width:64px;height:64px;border-radius:20px;background:var(--primary-soft);color:var(--primary);display:grid;place-items:center;margin:0 auto 20px}
  .empty b{display:block;font-size:19px;margin-bottom:8px}
  .empty p{margin:0;color:var(--muted);font-size:14px;line-height:1.6;word-break:keep-all}

  /* file chips */
  .files{display:flex;flex-wrap:wrap;gap:8px;margin-bottom:20px}
  .chip{display:inline-flex;align-items:center;gap:8px;height:36px;padding:0 6px 0 12px;background:var(--card);border-radius:999px;font-size:13px;color:var(--sub);max-width:320px}
  .chip .dot{width:8px;height:8px;border-radius:50%;flex:none}
  .chip .nm{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
  .chip .ct{color:var(--muted);flex:none}
  .chip .x{width:24px;height:24px;border-radius:50%;display:grid;place-items:center;color:var(--danger);flex:none;transition:background .15s var(--ease)}
  .chip .x:hover{background:var(--danger-soft2);color:var(--danger)}
  .chip.locked{background:var(--warn-soft,#FFF4E6);color:var(--warn)}
  .chip.locked .unlock{font-weight:600;color:var(--warn);text-decoration:underline;text-underline-offset:2px;padding:0 4px}
  .chip.error{background:var(--danger-soft2);color:var(--danger)}

  /* page grid */
  .hint{font-size:13px;color:var(--muted);margin:0 0 12px}
  .grid{position:relative;z-index:0;isolation:isolate;display:flex;flex-wrap:wrap;gap:16px;align-items:flex-start}
  .group{background:var(--card);border-radius:20px;padding:12px;cursor:grab;user-select:none;max-width:100%;transition:box-shadow .2s var(--ease);box-shadow:0 0 0 1.5px var(--ring,transparent)}
  .group:hover{box-shadow:0 0 0 1.5px var(--ring-h,transparent),0 4px 16px var(--shadow)}
  .group.enter{animation:enter .35s var(--ease) both}
  .g-head{display:flex;align-items:center;gap:8px;height:28px;margin:0 2px 10px;font-size:13px;color:var(--sub)}
  .g-head .dot{width:8px;height:8px;border-radius:50%;flex:none}
  .g-head .nm{white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:260px;font-weight:600;color:var(--ink);font-size:14px}
  .g-head .fn{white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:160px;color:var(--muted);flex:0 1 auto;min-width:0}
  .g-head .fn:empty{display:none}
  .g-head .ct{color:var(--muted);flex:none}
  .g-head .sp{flex:1}
  .g-btn{height:28px;padding:0 10px;border-radius:8px;font-size:12px;font-weight:600;color:var(--sub);background:var(--fill);flex:none;opacity:0;transition:opacity .15s var(--ease),background .15s var(--ease)}
  .g-btn:hover{background:var(--line);color:var(--ink)}
  .g-btn.x{width:28px;padding:0;display:grid;place-items:center;color:var(--danger);background:var(--danger-soft)}
  .g-btn.x:hover{background:var(--danger-soft2);color:var(--danger)}
  .group:hover .g-btn,.group:focus-within .g-btn{opacity:1}
  .group:not(.stack){flex:1 1 100%;min-width:0}
  .g-wrap{position:relative}
  .g-body{display:flex;flex-wrap:nowrap;gap:22px;overflow-x:auto;overscroll-behavior-x:contain;padding:4px 14px 8px;margin:0 -12px;scrollbar-width:none}
  .g-body::-webkit-scrollbar{display:none}
  .g-body .page{width:128px;cursor:grab}
  .g-body .thumb{background:var(--paper);box-shadow:0 0 0 1px var(--line)}
  .g-body .thumb img{box-shadow:none}
  .g-body .cut{left:-11px;margin-left:-12px}
  .page.flash .thumb{animation:flash 1.4s var(--ease)}
  @keyframes flash{0%,60%{box-shadow:0 0 0 3px var(--primary)}100%{box-shadow:0 0 0 1px var(--line)}}
  .fade{position:absolute;top:0;bottom:0;width:56px;pointer-events:none;opacity:0;transition:opacity .2s var(--ease);z-index:3}
  .fade.l{left:-12px;background:linear-gradient(90deg,var(--card) 30%,transparent)}
  .fade.r{right:-12px;background:linear-gradient(270deg,var(--card) 30%,transparent)}
  .g-wrap.can-l .fade.l,.g-wrap.can-r .fade.r{opacity:1}
  .scroll-btn{position:absolute;top:calc(50% - 32px);width:36px;height:36px;border-radius:50%;background:var(--elev);box-shadow:0 2px 8px var(--shadow2);display:grid;place-items:center;color:var(--sub);z-index:4;opacity:0;pointer-events:none;transition:opacity .2s var(--ease)}
  .scroll-btn:hover{color:var(--ink)}
  .scroll-btn.l{left:-4px} .scroll-btn.r{right:-4px}
  .g-wrap.can-l .scroll-btn.l,.g-wrap.can-r .scroll-btn.r{opacity:1;pointer-events:auto}
  .track{position:relative;height:6px;border-radius:6px;background:var(--fill);margin:6px 2px 0;cursor:pointer;touch-action:none}
  .track[hidden]{display:none}
  .track .thumbbar{position:absolute;top:0;bottom:0;left:0;border-radius:6px;background:var(--track);cursor:grab;transition:background .15s}
  .track:hover .thumbbar,.track.drag .thumbbar{background:var(--track-h)}
  .track.drag .thumbbar{cursor:grabbing}
  .track::before{content:'';position:absolute;inset:-8px 0}
  .jump{display:flex;align-items:center;gap:6px;height:28px;padding:0 4px 0 10px;border-radius:8px;background:var(--fill);font-size:12px;color:var(--muted);flex:none}
  .jump input{width:38px;height:22px;border:1px solid var(--line);border-radius:6px;background:var(--card);text-align:center;font:inherit;font-size:12px;color:var(--ink);outline:none;-moz-appearance:textfield}
  .jump input:focus{border-color:var(--primary)}
  .jump input::-webkit-outer-spin-button,.jump input::-webkit-inner-spin-button{-webkit-appearance:none;margin:0}
  .group.stack{width:180px;padding:12px;position:relative}
  .sheets{position:relative}
  .sheets.n2{margin:0 6px 6px 0} .sheets.n3{margin:0 12px 12px 0}
  .sheet{position:absolute;inset:0;border-radius:10px;background:var(--paper2);box-shadow:0 0 0 1px var(--line),0 1px 2px rgba(0,27,55,.06)}
  .sheet.s2{transform:translate(6px,6px)} .sheet.s3{transform:translate(12px,12px)}
  .group.stack:hover .sheet.s2{transform:translate(7px,7px)} .group.stack:hover .sheet.s3{transform:translate(14px,14px)}
  .sheet{transition:transform .2s var(--ease)}
  .stack .thumb{position:relative;z-index:1;background:var(--paper);box-shadow:0 0 0 1px var(--line)}
  .stack .thumb img{box-shadow:none}
  .stack .acts{top:18px;right:18px;z-index:2}
  .group.stack:hover .acts,.group.stack:focus-within .acts{opacity:1}
  .c-title{margin:12px 2px 0;font-size:13px;font-weight:600;color:var(--ink);line-height:1.4;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;word-break:keep-all;min-height:18px}
  .c-meta{display:flex;align-items:center;gap:6px;margin:6px 2px 0;font-size:12px;color:var(--muted);min-width:0}
  .c-meta .dot{width:6px;height:6px;border-radius:50%;flex:none}
  .c-meta .hd-fn{white-space:nowrap;overflow:hidden;text-overflow:ellipsis;min-width:0}
  .hd-fn:empty{display:none}
  .c-meta .ct{flex:none}
  .page{width:150px;position:relative;flex:none}
  .cut{position:absolute;left:-14px;top:calc(50% - 24px);width:24px;height:24px;margin-left:-7px;border-radius:50%;background:var(--elev);color:var(--sub);box-shadow:0 1px 4px rgba(0,27,55,.18);display:grid;place-items:center;opacity:0;transform:scale(.8);transition:opacity .15s var(--ease),transform .15s var(--ease),color .15s;z-index:2}
  .group:hover .cut{opacity:1;transform:none}
  .cut:hover{color:var(--primary)}
  .page.enter{animation:enter .35s var(--ease) both}
  @keyframes enter{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:none}}
  .thumb{aspect-ratio:1/1.414;border-radius:10px;background:var(--fill);display:grid;place-items:center;overflow:hidden}
  .thumb img{max-width:100%;max-height:100%;display:block;box-shadow:0 0 0 1px var(--line);transition:transform .25s var(--ease)}
  .thumb.rot90 img,.thumb.rot270 img{max-width:70.7%}
  .skeleton{width:100%;height:100%;background:linear-gradient(90deg,var(--sk1) 25%,var(--sk2) 50%,var(--sk1) 75%);background-size:200% 100%;animation:shimmer 1.2s linear infinite}
  @keyframes shimmer{from{background-position:200% 0}to{background-position:-200% 0}}
  .badge{min-width:24px;height:22px;padding:0 7px;border-radius:999px;background:var(--badge-bg);color:var(--badge-fg);font-size:12px;font-weight:700;display:grid;place-items:center;flex:none}
  .acts{position:absolute;top:6px;right:6px;display:flex;gap:4px;opacity:0;transition:opacity .15s var(--ease)}
  .page:hover .acts,.page:focus-within .acts{opacity:1}
  .act{width:32px;height:32px;border-radius:10px;background:var(--elev);box-shadow:0 1px 4px var(--shadow2);display:grid;place-items:center;color:var(--sub)}
  .act:hover{color:var(--ink)}
  .act.del{color:var(--danger)}
  .act.del:hover{background:var(--danger-soft);color:var(--danger)}
  .cap{display:flex;align-items:center;gap:8px;margin-top:8px;font-size:12px;color:var(--muted);padding:0 2px}
  .cap .dot{width:6px;height:6px;border-radius:50%;flex:none}
  .cap .nm{white-space:nowrap;overflow:hidden;text-overflow:ellipsis;flex:1}
  .ghost{opacity:.35}
  .chosen{box-shadow:0 0 0 1.5px var(--ring-h,transparent),0 12px 32px var(--shadow2)!important}

  /* bottom bar */
  .bar{position:fixed;left:0;right:0;bottom:0;z-index:10;background:var(--bar-bg);border-top:1px solid var(--line);transform:translateY(100%);transition:transform .3s var(--ease)}
  .bar.show{transform:none}
  .bar .in{max-width:1080px;margin:0 auto;padding:14px 24px;display:flex;align-items:center;gap:12px}
  .sum{font-size:14px;color:var(--sub);flex:none}
  .sum b{color:var(--ink)}
  .name{flex:1;display:flex;align-items:center;height:44px;background:var(--fill);border-radius:12px;padding:0 14px;border:1px solid transparent}
  .name:focus-within{border-color:var(--primary);background:var(--card)}
  .name input{flex:1;border:0;background:none;font:inherit;font-size:15px;outline:none;min-width:0;color:var(--ink)}
  .name input::placeholder{color:var(--placeholder)}
  .name span{color:var(--muted);font-size:15px}
  .warn{font-size:13px;color:var(--warn)}
  .spin{width:18px;height:18px;border-radius:50%;border:2.5px solid rgba(255,255,255,.4);border-top-color:#fff;animation:spin .7s linear infinite}
  @keyframes spin{to{transform:rotate(360deg)}}

  /* toast */
  .toast{position:fixed;z-index:30;left:50%;bottom:96px;transform:translate(-50%,12px);opacity:0;pointer-events:none;background:var(--toast);color:#fff;border-radius:999px;padding:12px 20px;font-size:14px;display:flex;align-items:center;gap:14px;transition:opacity .2s var(--ease),transform .2s var(--ease);white-space:nowrap}
  .toast.show{opacity:1;transform:translate(-50%,0);pointer-events:auto}
  .toast button{color:#64A8FF;font-weight:600;display:inline-flex;align-items:center;gap:8px}
  .toast kbd{font:inherit;font-size:11px;font-weight:600;color:#C5CCD3;background:rgba(255,255,255,.12);border:1px solid rgba(255,255,255,.18);border-bottom-width:2px;border-radius:6px;padding:1px 6px;letter-spacing:.02em}
  @media (hover:none){ .toast kbd{display:none} }

  /* modal */
  .scrim{position:fixed;inset:0;z-index:40;background:rgba(0,0,0,.4);display:grid;place-items:center;opacity:0;pointer-events:none;transition:opacity .2s var(--ease)}
  .scrim.show{opacity:1;pointer-events:auto}
  .modal{background:var(--card);border-radius:24px;width:min(400px,calc(100% - 40px));padding:28px 24px 20px;transform:scale(.96);transition:transform .2s var(--ease)}
  .scrim.show .modal{transform:none}
  .modal h2{font-size:20px;margin:0 0 8px}
  .modal p{margin:0 0 20px;color:var(--sub);font-size:14px;line-height:1.5;word-break:keep-all}
  .modal p b{color:var(--ink);font-weight:600}
  .field{height:52px;border-radius:14px;background:var(--fill);border:1px solid var(--line);display:flex;align-items:center;padding:0 16px}
  .field.err{border-color:var(--danger)}
  .field input{flex:1;border:0;background:none;font:inherit;font-size:16px;outline:none}
  .err-msg{color:var(--danger);font-size:13px;margin:8px 2px 0;min-height:18px}
  .modal .row{display:flex;gap:8px;margin-top:16px}
  .modal .row .btn{flex:1;justify-content:center;height:52px;border-radius:14px}
  .btn-ghost{background:var(--fill);color:var(--sub)}
  .btn-ghost:hover{background:var(--line)}

  /* window drop overlay */
  .drop-ov{position:fixed;inset:12px;z-index:50;border-radius:24px;border:2px dashed var(--primary);background:var(--drop-bg,rgba(232,243,255,.85));display:grid;place-items:center;font-size:18px;font-weight:700;color:var(--primary);opacity:0;pointer-events:none;transition:opacity .15s var(--ease)}
  .drop-ov.show{opacity:1}
  /* viewer */
  .viewer{position:fixed;inset:0;background:rgba(15,19,25,.92);display:flex;flex-direction:column;opacity:0;pointer-events:none;transition:opacity .2s var(--ease);z-index:20}
  .viewer.show{opacity:1;pointer-events:auto}
  .v-top{display:flex;align-items:center;gap:12px;padding:16px 20px;color:#fff;padding-top:max(16px,env(safe-area-inset-top))}
  .v-title{flex:1;min-width:0;font-size:15px;display:flex;align-items:center;gap:10px}
  .v-title .badge{background:#fff;color:#191F28}
  .v-title .nm{white-space:nowrap;overflow:hidden;text-overflow:ellipsis;color:#D1D6DB}
  .v-btn{width:44px;height:44px;border-radius:14px;display:grid;place-items:center;color:#fff;flex:none}
  .v-btn:hover:not(:disabled){background:rgba(255,255,255,.12)}
  .v-btn:disabled{opacity:.3}
  .v-body{flex:1;min-height:0;display:flex;align-items:center;gap:8px;padding:0 12px 24px;padding-bottom:max(24px,env(safe-area-inset-bottom))}
  .v-stage{flex:1;height:100%;position:relative;overflow:hidden;min-width:0;touch-action:pan-y}
  .v-stage img{position:absolute;left:50%;top:50%;transform:translate(-50%,-50%);background:#fff;border-radius:4px;box-shadow:0 8px 40px rgba(0,0,0,.4);transition:transform .25s var(--ease),opacity .15s var(--ease)}
  .v-stage .skeleton{position:absolute;left:50%;top:50%;transform:translate(-50%,-50%);width:min(60vh,80vw);aspect-ratio:1/1.414;border-radius:4px;opacity:.15}
  .thumb{cursor:zoom-in}

  @media (max-width:640px){
    .wrap{padding:28px 16px 150px}
    header{flex-direction:column;align-items:stretch;gap:14px}
    header > div:first-child{width:100%}
    h1{flex-wrap:wrap;row-gap:2px}
    .hdr-r{width:100%;justify-content:flex-end;gap:4px}
    .hdr-r .lang{margin-right:auto}
    .lang-menu{left:0;right:auto;transform-origin:top left}
    h1{font-size:22px}
    .lead{font-size:13px}
    .btn-secondary{height:40px;padding:0 14px;font-size:14px}
    .theme-btn{width:40px;height:40px}
    header > div:first-child{min-width:0}
    .grid{gap:12px}
    .group{width:100%;padding:10px}
    .g-body{gap:10px}
    .g-body .page{width:38vw}
    .group:not(.stack) .g-head{flex-wrap:wrap;height:auto;row-gap:8px}
    .group:not(.stack) .g-head .sp{flex-basis:100%;height:0}
    .group:not(.stack) .g-head .nm{flex:1 1 auto}
    .scroll-btn{display:none}
    .jump .lbl{display:none}
    .group.stack{width:calc(50% - 6px)}
    .g-body .cut{left:-11px;margin-left:-12px}
    .g-head .nm{max-width:none;flex:0 1 auto;min-width:0}
    .g-head .fn{display:none}
    .bar .in{flex-wrap:wrap;padding:12px 16px;padding-bottom:max(12px,env(safe-area-inset-bottom))}
    .sum{order:0;flex:1}
    .warn{order:1;width:100%}
    .name{order:2;flex:1 1 100%}
    .btn-primary{order:3;flex:1 1 100%;height:52px;border-radius:14px}
    .toast{bottom:170px}
    .empty{padding:56px 20px}
    .v-body .v-btn{display:none}
  }
  /* 터치 기기: 버튼 항상 보이기 */
  @media (hover:none){ .acts,.g-btn,.cut,.group.stack .acts{opacity:1;transform:none} .group:hover{box-shadow:0 0 0 1.5px var(--ring,transparent)} .empty:hover{border-color:transparent} }
  footer{margin-top:48px;text-align:center;font-size:12px;color:var(--muted);letter-spacing:0}
  footer b{font-weight:600;color:var(--sub)}
  .hdr-r{display:flex;align-items:center;gap:8px}
  .lang{position:relative;z-index:15}
  .lang-btn{height:44px;display:flex;align-items:center;gap:8px;padding:0 10px 0 12px;border-radius:12px;color:var(--sub);font-size:14px;font-weight:600;transition:background .15s var(--ease),color .15s}
  .lang-btn:hover,.lang-btn[aria-expanded="true"]{background:var(--card);color:var(--ink)}
  .lang-btn:focus-visible{outline:none;box-shadow:0 0 0 2px var(--primary)}
  .lang-btn .chev{color:var(--muted);transition:transform .2s var(--ease)}
  .lang-btn[aria-expanded="true"] .chev{transform:rotate(180deg)}
  .lang-menu{position:absolute;top:calc(100% + 8px);right:0;min-width:260px;margin:0;padding:6px;list-style:none;background:var(--card);border-radius:16px;box-shadow:0 0 0 1px var(--line),0 12px 32px var(--shadow2);transform-origin:top right;animation:pop .16s var(--ease)}
  .lang-menu[hidden]{display:none}
  @keyframes pop{from{opacity:0;transform:translateY(-4px) scale(.97)}to{opacity:1;transform:none}}
  .lang-menu li{display:flex;align-items:center;gap:10px;height:42px;padding:0 12px;white-space:nowrap;border-radius:10px;font-size:14px;color:var(--ink);cursor:pointer;outline:none;transition:background .12s}
  .lang-menu li:hover,.lang-menu li:focus-visible,.lang-menu li.kb{background:var(--fill)}
  .lang-menu li .en{margin-left:auto;padding-left:12px;font-size:12px;color:var(--muted)}
  .lang-menu li .ck{width:16px;flex:none;color:var(--primary);visibility:hidden}
  .lang-menu li[aria-selected="true"]{background:var(--primary-soft);color:var(--primary);font-weight:600}
  .lang-menu li[aria-selected="true"] .ck{visibility:visible}
  .lang-menu li[aria-selected="true"] .en{color:var(--primary);opacity:.7}
  [data-theme="dark"] .lang-menu li[aria-selected="true"],[data-theme="dark"] .lang-menu li .ck{color:#6AA8FF}
  .theme-btn{width:44px;height:44px;border-radius:12px;display:grid;place-items:center;color:var(--sub);transition:background .15s var(--ease),color .15s}
  .theme-btn:hover{background:var(--card);color:var(--ink)}
  .theme-btn .i-sun{display:none}
  [data-theme="dark"] .theme-btn .i-sun{display:block} [data-theme="dark"] .theme-btn .i-moon{display:none}
  body,.group,.chip,.bar,.empty,.modal,.name,.btn-secondary,.g-btn,.act,.jump{transition:background-color .25s var(--ease),color .25s var(--ease),border-color .25s var(--ease),box-shadow .2s var(--ease)}

  /* ---------- 다크 모드 ---------- */
  [data-theme="dark"]{
    --bg:#17171C; --card:#212128; --ink:#F2F4F6; --sub:#B0B8C1; --muted:#7E8794; --line:#33333D; --fill:#2A2A32;
    --primary:#3182F6; --primary-press:#4C94FF; --primary-soft:rgba(49,130,246,.18); --primary-soft2:rgba(49,130,246,.28); --primary-dis:#25406A; --danger:#FF6B76;
    --elev:#2E2E37; --danger-soft:rgba(255,107,118,.12); --danger-soft2:rgba(255,107,118,.22); --shadow:rgba(0,0,0,.35); --shadow2:rgba(0,0,0,.5);
    --badge-bg:#E5E8EB; --badge-fg:#17171C; --paper:#FFFFFF; --paper2:#C9CED6; --placeholder:#5C6470; --warn:#FFB35C; --warn-soft:rgba(255,138,0,.16);
    --bar-bg:rgba(33,33,40,.96); --toast:#3E3E4A; --sk1:#2A2A32; --sk2:#34343E; --track:#4E5662; --track-h:#8B95A1; --drop-bg:rgba(23,32,50,.88);
  }
  [data-theme="dark"] .btn-secondary{color:#6AA8FF}
  [data-theme="dark"] .empty .ico{color:#6AA8FF}
  [data-theme="dark"] .lead svg{color:#6AA8FF}
  [data-theme="dark"] .sheet.s3{background:#A9B1BC}
  [data-theme="dark"] .chosen{background:var(--card)}

  @media (prefers-reduced-motion:reduce){ *{animation:none!important;transition:none!important} }
</style>
</head>
<body>
<div class="wrap">
  <header>
    <div>
      <h1><span data-i18n="brand">합본</span> <span class="h1-sub" data-i18n="sub">PDF 합치기</span></h1>
      <p class="lead">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/></svg>
        <span data-i18n="lead">파일은 이 컴퓨터 밖으로 나가지 않아요</span>
      </p>
    </div>
    <div class="hdr-r">
      <div class="lang" id="langBox">
        <button class="lang-btn" id="langBtn" aria-haspopup="listbox" aria-expanded="false" aria-controls="langMenu" data-i18n-aria="lang" data-i18n-title="lang">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c2.5 2.6 3.8 5.6 3.8 9s-1.3 6.4-3.8 9M12 3C9.5 5.6 8.2 8.6 8.2 12s1.3 6.4 3.8 9"/></svg>
          <span id="langCur"></span>
          <svg class="chev" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M6 9l6 6 6-6"/></svg>
        </button>
        <ul class="lang-menu" id="langMenu" role="listbox" hidden></ul>
      </div>
      <button class="theme-btn" id="themeBtn" aria-label="화면 모드 바꾸기" data-i18n-aria="theme">
        <svg class="i-moon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z"/></svg>
        <svg class="i-sun" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><circle cx="12" cy="12" r="4.2"/><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"/></svg>
      </button>
      <button class="btn btn-secondary" id="addBtn" hidden>
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round"><path d="M12 5v14M5 12h14"/></svg>
        <span data-i18n="add">파일 추가</span>
      </button>
    </div>
  </header>

  <div class="empty" id="empty" role="button" tabindex="0">
    <div class="ico"><svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8z"/><path d="M14 3v5h5M12 18v-6M9 15h6"/></svg></div>
    <b id="emptyTitle">PDF나 사진을 끌어다 놓으세요</b>
    <p>눌러서 고를 수도 있어요 · PDF, 사진(JPG, PNG, HEIC)<br>넣은 파일의 모든 페이지를 원하는 순서로 섞을 수 있어요</p>
  </div>

  <section id="work" hidden>
    <div class="files" id="files"></div>
    <p class="hint" id="hint">끌어서 순서를 바꾸세요. 여러 쪽짜리 PDF는 겹쳐서 함께 움직이고, 펼치면 쪽별로 보고 나눌 수 있어요.</p>
    <div class="grid" id="grid"></div>
  </section>
  <footer>Created by <b>임휘훈</b></footer>
</div>

<div class="bar" id="bar">
  <div class="in">
    <div class="sum" id="sum"></div>
    <label class="name"><input id="outname" value="" placeholder="합본 이름 적기" aria-label="합본 파일 이름" data-i18n-ph="namePh" data-i18n-aria="nameAria" spellcheck="false" autocomplete="off"><span>.pdf</span></label>
    <span class="warn" id="warn" hidden></span>
    <button class="btn btn-primary" id="saveBtn" data-i18n="save">PDF로 저장</button>
  </div>
</div>

<div class="toast" id="toast" role="status"><span id="toastMsg"></span><button id="toastAct" hidden><span data-i18n="undo">되돌리기</span><kbd id="undoKey">Ctrl+Z</kbd></button></div>

<div class="scrim" id="scrim">
  <form class="modal" id="pwForm" autocomplete="off">
    <h2 data-i18n="pwTitle">암호를 입력해 주세요</h2>
    <p><b id="pwName"></b><span data-i18n="pwDesc"> 파일에 암호가 걸려 있어요. 암호를 입력하면 풀린 상태로 합쳐요.</span></p>
    <div class="field" id="pwField"><input type="password" id="pwInput" placeholder="PDF 암호" data-i18n-ph="pwPh"></div>
    <div class="err-msg" id="pwErr"></div>
    <div class="row">
      <button type="button" class="btn btn-ghost" id="pwLater" data-i18n="later">나중에</button>
      <button type="submit" class="btn btn-primary" data-i18n="ok">확인</button>
    </div>
  </form>
</div>

<div class="viewer" id="viewer" role="dialog" aria-modal="true" aria-label="페이지 크게 보기" data-i18n-aria="viewer">
  <div class="v-top">
    <div class="v-title"><span class="badge" id="vNum"></span><span class="nm" id="vName"></span></div>
    <button class="v-btn" id="vRot" title="오른쪽으로 돌리기" aria-label="오른쪽으로 돌리기" data-i18n-title="rotate" data-i18n-aria="rotate"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12a9 9 0 1 1-3-6.7L21 8"/><path d="M21 3v5h-5"/></svg></button>
    <button class="v-btn" id="vClose" title="닫기 (Esc)" aria-label="닫기" data-i18n-title="close|(Esc)" data-i18n-aria="close"><svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round"><path d="M6 6l12 12M18 6L6 18"/></svg></button>
  </div>
  <div class="v-body">
    <button class="v-btn" id="vPrev" title="이전 페이지 (←)" aria-label="이전 페이지" data-i18n-title="prev|(←)" data-i18n-aria="prev"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M15 6l-6 6 6 6"/></svg></button>
    <div class="v-stage" id="vStage"></div>
    <button class="v-btn" id="vNext" title="다음 페이지 (→)" aria-label="다음 페이지" data-i18n-title="next|(→)" data-i18n-aria="next"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M9 6l6 6-6 6"/></svg></button>
  </div>
</div>

<div class="drop-ov" id="dropOv" data-i18n="dropHere">여기에 놓으면 추가돼요</div>
<input type="file" id="picker" accept="application/pdf,image/*" multiple hidden>

<script>__PDFLIB__</script>
<script>__PDFJS__</script>
<script>__SORTABLE__</script>
<script id="worker-src" type="text/plain">__WORKER__</script>
<script id="cmaps" type="application/json">__CMAPS__</script>
<script>
(function(){
  // 한국어 PDF용 문자 변환표(CMap)를 파일 안에서 바로 읽기
  const CMAPS = JSON.parse(document.getElementById('cmaps').textContent);
  class LocalCMapFactory {
    constructor(){}
    async fetch({name}){
      const b64 = CMAPS[name];
      if (!b64) throw new Error('CMap not bundled: ' + name);
      const bin = atob(b64), u = new Uint8Array(bin.length);
      for (let i = 0; i < bin.length; i++) u[i] = bin.charCodeAt(i);
      return {cMapData: u, compressionType: 1};
    }
  }
  const DOC_OPTS = {CMapReaderFactory: LocalCMapFactory, cMapUrl: 'local/', cMapPacked: true, useWorkerFetch: false, isEvalSupported: false};
  pdfjsLib.GlobalWorkerOptions.workerSrc = URL.createObjectURL(new Blob([document.getElementById('worker-src').textContent], {type:'text/javascript'}));

  /* ---------- 번역표 ---------- */
  const LANGS = [['ko','한국어','Korean'],['en','English','English'],['ja','日本語','Japanese'],['zh-CN','简体中文','Chinese (Simplified)'],['zh-TW','繁體中文','Chinese (Traditional)'],['es','Español','Spanish'],['fr','Français','French'],['de','Deutsch','German']];
  const plural = (n, one, many) => n === 1 ? one : many;
  const I18N = {
    ko: {
      brand:'합본', sub:'PDF 합치기', lead:'파일은 이 컴퓨터 밖으로 나가지 않아요', add:'파일 추가', lang:'언어',
      emptyTitle:'PDF나 사진을 끌어다 놓으세요', emptyTitleTouch:'눌러서 PDF나 사진을 골라 주세요',
      orClick:'눌러서 고를 수도 있어요', formats:'PDF, 사진(JPG, PNG, HEIC)', mix:'넣은 파일의 모든 페이지를 원하는 순서로 섞을 수 있어요',
      hint:'끌어서 순서를 바꾸세요. 여러 쪽짜리 PDF는 겹쳐서 함께 움직이고, 펼치면 쪽별로 보고 나눌 수 있어요.',
      hintTouch:'꾹 눌러서 끌면 순서가 바뀌어요. 여러 쪽짜리는 펼쳐서 쪽별로 나눌 수 있어요.',
      namePh:'합본 이름 적기', nameAria:'합본 파일 이름', save:'PDF로 저장', saving:'만드는 중', undo:'되돌리기',
      pwTitle:'암호를 입력해 주세요', pwDesc:' 파일에 암호가 걸려 있어요. 암호를 입력하면 풀린 상태로 합쳐요.', pwPh:'PDF 암호', later:'나중에', ok:'확인',
      pwWrong:'암호가 맞지 않아요. 다시 확인해 주세요', unlocked:'암호를 풀었어요',
      viewer:'페이지 크게 보기', rotate:'오른쪽으로 돌리기', close:'닫기', prev:'이전 페이지', next:'다음 페이지', dropHere:'여기에 놓으면 추가돼요',
      toDark:'다크 모드로 바꾸기', toLight:'라이트 모드로 바꾸기', theme:'화면 모드 바꾸기',
      nothingUndo:'더 되돌릴 작업이 없어요', undone:'되돌렸어요', onlyPdfImg:'PDF나 사진만 넣을 수 있어요',
      badPhoto: n => `${n}은(는) 이 브라우저에서 열 수 없는 사진이에요`,
      cantOpen:'열 수 없는 파일', enterPw:'암호 입력', removeFile:'파일 빼기', andMore:(n,k) => `${n} 외 ${k}개`,
      expand:'쪽별로 펼치기', removeGroup:'이 묶음 빼기', removePage:'이 페이지 빼기',
      jumpTitle:'이 묶음 안의 쪽 번호로 이동', jumpLbl:'쪽 이동', jumpAria:'이동할 쪽 번호',
      fold:'접기', foldTitle:'다시 겹쳐서 보기', split:'묶음 풀기', splitTitle:'한 쪽씩 따로 움직이게 풀기', join:'앞과 묶기', joinTitle:'바로 앞 묶음과 합치기',
      scrollL:'왼쪽으로 넘기기', scrollR:'오른쪽으로 넘기기', cut:'여기서 나누기',
      toastSplit:'묶음을 나눴어요', toastUngroup:'한 쪽씩 따로 움직일 수 있어요', toastJoin:'앞 묶음과 합쳤어요',
      removedCount: n => `${n}쪽을 뺐어요`, removedPageNo: n => `${n}쪽을 뺐어요`, removedFile: n => `${n}을(를) 뺐어요`,
      pages: n => `${n}쪽`, pageNo: n => `${n}쪽`, sum:(p,f) => `<b>${p}</b> · 파일 ${f}개`,
      lockedWarn:'암호를 입력하지 않은 파일은 빠져요', defaultName:'합본', saved: n => `${n}을(를) 저장했어요`, saveFail:'저장하지 못했어요. 파일을 다시 확인해 주세요'
    },
    en: {
      brand:'Hapbon', sub:'PDF Merge', lead:'Your files never leave this device', add:'Add files', lang:'Language',
      emptyTitle:'Drop PDFs or photos here', emptyTitleTouch:'Tap to choose PDFs or photos',
      orClick:'Or click to choose', formats:'PDF, photos (JPG, PNG, HEIC)', mix:'Arrange every page of every file in any order',
      hint:'Drag to reorder. Multi-page PDFs move together as a stack; expand one to see and split its pages.',
      hintTouch:'Press and hold to drag. Expand multi-page PDFs to split them.',
      namePh:'Name your file', nameAria:'File name', save:'Save PDF', saving:'Creating', undo:'Undo',
      pwTitle:'Enter password', pwDesc:' is password-protected. Enter the password to add it unlocked.', pwPh:'PDF password', later:'Later', ok:'OK',
      pwWrong:'Wrong password. Please try again.', unlocked:'Unlocked',
      viewer:'Page preview', rotate:'Rotate right', close:'Close', prev:'Previous page', next:'Next page', dropHere:'Drop to add',
      toDark:'Switch to dark mode', toLight:'Switch to light mode', theme:'Toggle theme',
      nothingUndo:'Nothing to undo', undone:'Undone', onlyPdfImg:'Only PDFs and photos can be added',
      badPhoto: n => `Can't open ${n} in this browser`,
      cantOpen:"Can't open", enterPw:'Enter password', removeFile:'Remove file', andMore:(n,k) => `${n} +${k} more`,
      expand:'Expand pages', removeGroup:'Remove this stack', removePage:'Remove this page',
      jumpTitle:'Go to a page in this stack', jumpLbl:'Go to', jumpAria:'Page number',
      fold:'Collapse', foldTitle:'Stack again', split:'Ungroup', splitTitle:'Move pages one by one', join:'Join previous', joinTitle:'Merge with the previous stack',
      scrollL:'Scroll left', scrollR:'Scroll right', cut:'Split here',
      toastSplit:'Split', toastUngroup:'Pages can now move one by one', toastJoin:'Joined with previous',
      removedCount: n => `Removed ${plural(n,'1 page',n+' pages')}`, removedPageNo: n => `Removed page ${n}`, removedFile: n => `Removed ${n}`,
      pages: n => plural(n,'1 page',`${n} pages`), pageNo: n => `p. ${n}`, sum:(p,f) => `<b>${p}</b> · ${plural(f,'1 file',f+' files')}`,
      lockedWarn:'Files without a password will be skipped', defaultName:'merged', saved: n => `Saved ${n}`, saveFail:"Couldn't save. Please check your files."
    },
    ja: {
      brand:'Hapbon', sub:'PDF結合', lead:'ファイルはこのデバイスの外に出ません', add:'ファイルを追加', lang:'言語',
      emptyTitle:'PDFや写真をここにドロップ', emptyTitleTouch:'タップしてPDFや写真を選択',
      orClick:'クリックして選ぶこともできます', formats:'PDF、写真（JPG・PNG・HEIC）', mix:'すべてのファイルのすべてのページを好きな順番に並べられます',
      hint:'ドラッグで並べ替えます。複数ページのPDFは重なったまままとめて動き、展開するとページごとに見て分割できます。',
      hintTouch:'長押ししてドラッグで並べ替え。複数ページは展開して分割できます。',
      namePh:'ファイル名を入力', nameAria:'ファイル名', save:'PDFを保存', saving:'作成中', undo:'元に戻す',
      pwTitle:'パスワードを入力してください', pwDesc:' はパスワードで保護されています。入力すると解除した状態で結合します。', pwPh:'PDFのパスワード', later:'あとで', ok:'OK',
      pwWrong:'パスワードが違います。もう一度確認してください', unlocked:'解除しました',
      viewer:'ページを拡大表示', rotate:'右に回転', close:'閉じる', prev:'前のページ', next:'次のページ', dropHere:'ドロップして追加',
      toDark:'ダークモードに切り替え', toLight:'ライトモードに切り替え', theme:'表示モードを切り替え',
      nothingUndo:'元に戻す操作はありません', undone:'元に戻しました', onlyPdfImg:'追加できるのはPDFと写真だけです',
      badPhoto: n => `${n} はこのブラウザで開けません`,
      cantOpen:'開けません', enterPw:'パスワード入力', removeFile:'ファイルを外す', andMore:(n,k) => `${n} ほか${k}件`,
      expand:'ページを展開', removeGroup:'このまとまりを外す', removePage:'このページを外す',
      jumpTitle:'このまとまりのページへ移動', jumpLbl:'移動', jumpAria:'ページ番号',
      fold:'たたむ', foldTitle:'もう一度重ねる', split:'まとまりを解除', splitTitle:'1ページずつ動かせるようにする', join:'前とまとめる', joinTitle:'直前のまとまりと結合',
      scrollL:'左へスクロール', scrollR:'右へスクロール', cut:'ここで分割',
      toastSplit:'分割しました', toastUngroup:'1ページずつ動かせます', toastJoin:'前のまとまりと結合しました',
      removedCount: n => `${n}ページを外しました`, removedPageNo: n => `${n}ページ目を外しました`, removedFile: n => `${n} を外しました`,
      pages: n => `${n}ページ`, pageNo: n => `${n}ページ`, sum:(p,f) => `<b>${p}</b> · ファイル${f}件`,
      lockedWarn:'パスワード未入力のファイルは含まれません', defaultName:'結合', saved: n => `${n} を保存しました`, saveFail:'保存できませんでした。ファイルを確認してください'
    },
    'zh-CN': {
      brand:'Hapbon', sub:'PDF 合并', lead:'文件不会离开这台设备', add:'添加文件', lang:'语言',
      emptyTitle:'将 PDF 或照片拖到这里', emptyTitleTouch:'点按选择 PDF 或照片',
      orClick:'也可以点击选择', formats:'PDF、照片（JPG、PNG、HEIC）', mix:'所有文件的每一页都能按任意顺序排列',
      hint:'拖动即可调整顺序。多页 PDF 会叠在一起整体移动，展开后可逐页查看和拆分。',
      hintTouch:'长按拖动即可调整顺序。多页文件可展开后拆分。',
      namePh:'输入文件名', nameAria:'文件名', save:'保存 PDF', saving:'正在生成', undo:'撤销',
      pwTitle:'请输入密码', pwDesc:' 受密码保护。输入密码后将以解锁状态合并。', pwPh:'PDF 密码', later:'稍后', ok:'确定',
      pwWrong:'密码不正确，请重新输入', unlocked:'已解锁',
      viewer:'页面预览', rotate:'向右旋转', close:'关闭', prev:'上一页', next:'下一页', dropHere:'松开即可添加',
      toDark:'切换到深色模式', toLight:'切换到浅色模式', theme:'切换显示模式',
      nothingUndo:'没有可撤销的操作', undone:'已撤销', onlyPdfImg:'只能添加 PDF 和照片',
      badPhoto: n => `此浏览器无法打开 ${n}`,
      cantOpen:'无法打开', enterPw:'输入密码', removeFile:'移除文件', andMore:(n,k) => `${n} 等 ${k+1} 个`,
      expand:'展开页面', removeGroup:'移除这一组', removePage:'移除此页',
      jumpTitle:'跳转到本组中的某一页', jumpLbl:'跳转', jumpAria:'页码',
      fold:'收起', foldTitle:'重新叠起', split:'取消分组', splitTitle:'拆开后逐页移动', join:'与前一组合并', joinTitle:'与前一组合并',
      scrollL:'向左滚动', scrollR:'向右滚动', cut:'在此拆分',
      toastSplit:'已拆分', toastUngroup:'现在可以逐页移动', toastJoin:'已与前一组合并',
      removedCount: n => `已移除 ${n} 页`, removedPageNo: n => `已移除第 ${n} 页`, removedFile: n => `已移除 ${n}`,
      pages: n => `${n} 页`, pageNo: n => `第 ${n} 页`, sum:(p,f) => `<b>${p}</b> · ${f} 个文件`,
      lockedWarn:'未输入密码的文件不会包含在内', defaultName:'合并', saved: n => `已保存 ${n}`, saveFail:'保存失败，请检查文件'
    },
    'zh-TW': {
      brand:'Hapbon', sub:'PDF 合併', lead:'檔案不會離開這台裝置', add:'新增檔案', lang:'語言',
      emptyTitle:'將 PDF 或照片拖曳到這裡', emptyTitleTouch:'點按選擇 PDF 或照片',
      orClick:'也可以點擊選擇', formats:'PDF、照片（JPG、PNG、HEIC）', mix:'所有檔案的每一頁都能依任意順序排列',
      hint:'拖曳即可調整順序。多頁 PDF 會疊在一起整體移動，展開後可逐頁檢視與拆分。',
      hintTouch:'長按拖曳即可調整順序。多頁檔案可展開後拆分。',
      namePh:'輸入檔案名稱', nameAria:'檔案名稱', save:'儲存 PDF', saving:'正在產生', undo:'復原',
      pwTitle:'請輸入密碼', pwDesc:' 受密碼保護。輸入密碼後將以解鎖狀態合併。', pwPh:'PDF 密碼', later:'稍後', ok:'確定',
      pwWrong:'密碼不正確，請重新輸入', unlocked:'已解鎖',
      viewer:'頁面預覽', rotate:'向右旋轉', close:'關閉', prev:'上一頁', next:'下一頁', dropHere:'放開即可新增',
      toDark:'切換到深色模式', toLight:'切換到淺色模式', theme:'切換顯示模式',
      nothingUndo:'沒有可復原的操作', undone:'已復原', onlyPdfImg:'只能新增 PDF 和照片',
      badPhoto: n => `此瀏覽器無法開啟 ${n}`,
      cantOpen:'無法開啟', enterPw:'輸入密碼', removeFile:'移除檔案', andMore:(n,k) => `${n} 等 ${k+1} 個`,
      expand:'展開頁面', removeGroup:'移除這一組', removePage:'移除此頁',
      jumpTitle:'跳到本組中的某一頁', jumpLbl:'跳至', jumpAria:'頁碼',
      fold:'收合', foldTitle:'重新疊起', split:'取消分組', splitTitle:'拆開後逐頁移動', join:'與前一組合併', joinTitle:'與前一組合併',
      scrollL:'向左捲動', scrollR:'向右捲動', cut:'在此拆分',
      toastSplit:'已拆分', toastUngroup:'現在可以逐頁移動', toastJoin:'已與前一組合併',
      removedCount: n => `已移除 ${n} 頁`, removedPageNo: n => `已移除第 ${n} 頁`, removedFile: n => `已移除 ${n}`,
      pages: n => `${n} 頁`, pageNo: n => `第 ${n} 頁`, sum:(p,f) => `<b>${p}</b> · ${f} 個檔案`,
      lockedWarn:'未輸入密碼的檔案不會包含在內', defaultName:'合併', saved: n => `已儲存 ${n}`, saveFail:'儲存失敗，請檢查檔案'
    },
    es: {
      brand:'Hapbon', sub:'Unir PDF', lead:'Tus archivos nunca salen de este dispositivo', add:'Añadir archivos', lang:'Idioma',
      emptyTitle:'Arrastra aquí PDF o fotos', emptyTitleTouch:'Toca para elegir PDF o fotos',
      orClick:'O haz clic para elegir', formats:'PDF, fotos (JPG, PNG, HEIC)', mix:'Ordena todas las páginas de todos los archivos como quieras',
      hint:'Arrastra para reordenar. Los PDF de varias páginas se mueven juntos como una pila; despliégalos para ver y dividir sus páginas.',
      hintTouch:'Mantén pulsado para arrastrar. Despliega los PDF de varias páginas para dividirlos.',
      namePh:'Nombre del archivo', nameAria:'Nombre del archivo', save:'Guardar PDF', saving:'Creando', undo:'Deshacer',
      pwTitle:'Introduce la contraseña', pwDesc:' está protegido con contraseña. Introdúcela para añadirlo desbloqueado.', pwPh:'Contraseña del PDF', later:'Más tarde', ok:'Aceptar',
      pwWrong:'Contraseña incorrecta. Inténtalo de nuevo.', unlocked:'Desbloqueado',
      viewer:'Vista de página', rotate:'Girar a la derecha', close:'Cerrar', prev:'Página anterior', next:'Página siguiente', dropHere:'Suelta para añadir',
      toDark:'Cambiar a modo oscuro', toLight:'Cambiar a modo claro', theme:'Cambiar tema',
      nothingUndo:'No hay nada que deshacer', undone:'Deshecho', onlyPdfImg:'Solo se pueden añadir PDF y fotos',
      badPhoto: n => `No se puede abrir ${n} en este navegador`,
      cantOpen:'No se puede abrir', enterPw:'Contraseña', removeFile:'Quitar archivo', andMore:(n,k) => `${n} y ${k} más`,
      expand:'Desplegar páginas', removeGroup:'Quitar este grupo', removePage:'Quitar esta página',
      jumpTitle:'Ir a una página de este grupo', jumpLbl:'Ir a', jumpAria:'Número de página',
      fold:'Plegar', foldTitle:'Volver a apilar', split:'Desagrupar', splitTitle:'Mover las páginas por separado', join:'Unir con el anterior', joinTitle:'Unir con el grupo anterior',
      scrollL:'Desplazar a la izquierda', scrollR:'Desplazar a la derecha', cut:'Dividir aquí',
      toastSplit:'Dividido', toastUngroup:'Ahora puedes mover las páginas por separado', toastJoin:'Unido con el anterior',
      removedCount: n => plural(n,'Se quitó 1 página',`Se quitaron ${n} páginas`), removedPageNo: n => `Se quitó la página ${n}`, removedFile: n => `Se quitó ${n}`,
      pages: n => plural(n,'1 página',`${n} páginas`), pageNo: n => `pág. ${n}`, sum:(p,f) => `<b>${p}</b> · ${plural(f,'1 archivo',f+' archivos')}`,
      lockedWarn:'Los archivos sin contraseña se omitirán', defaultName:'combinado', saved: n => `Se guardó ${n}`, saveFail:'No se pudo guardar. Revisa los archivos.'
    },
    fr: {
      brand:'Hapbon', sub:'Fusion PDF', lead:'Vos fichiers ne quittent jamais cet appareil', add:'Ajouter des fichiers', lang:'Langue',
      emptyTitle:'Déposez des PDF ou des photos ici', emptyTitleTouch:'Touchez pour choisir des PDF ou des photos',
      orClick:'Ou cliquez pour choisir', formats:'PDF, photos (JPG, PNG, HEIC)', mix:'Réorganisez toutes les pages de tous les fichiers comme vous voulez',
      hint:'Faites glisser pour réorganiser. Les PDF de plusieurs pages se déplacent ensemble en pile ; dépliez-les pour voir et diviser leurs pages.',
      hintTouch:'Appuyez longuement pour déplacer. Dépliez les PDF de plusieurs pages pour les diviser.',
      namePh:'Nom du fichier', nameAria:'Nom du fichier', save:'Enregistrer le PDF', saving:'Création', undo:'Annuler',
      pwTitle:'Saisissez le mot de passe', pwDesc:' est protégé par un mot de passe. Saisissez-le pour l’ajouter déverrouillé.', pwPh:'Mot de passe du PDF', later:'Plus tard', ok:'OK',
      pwWrong:'Mot de passe incorrect. Réessayez.', unlocked:'Déverrouillé',
      viewer:'Aperçu de la page', rotate:'Pivoter à droite', close:'Fermer', prev:'Page précédente', next:'Page suivante', dropHere:'Déposez pour ajouter',
      toDark:'Passer en mode sombre', toLight:'Passer en mode clair', theme:'Changer de thème',
      nothingUndo:'Rien à annuler', undone:'Annulé', onlyPdfImg:'Seuls les PDF et les photos sont acceptés',
      badPhoto: n => `Impossible d’ouvrir ${n} dans ce navigateur`,
      cantOpen:'Illisible', enterPw:'Mot de passe', removeFile:'Retirer le fichier', andMore:(n,k) => `${n} et ${k} autre${k>1?'s':''}`,
      expand:'Déplier les pages', removeGroup:'Retirer ce groupe', removePage:'Retirer cette page',
      jumpTitle:'Aller à une page de ce groupe', jumpLbl:'Aller à', jumpAria:'Numéro de page',
      fold:'Replier', foldTitle:'Réempiler', split:'Dégrouper', splitTitle:'Déplacer les pages une par une', join:'Joindre au précédent', joinTitle:'Fusionner avec le groupe précédent',
      scrollL:'Défiler à gauche', scrollR:'Défiler à droite', cut:'Diviser ici',
      toastSplit:'Divisé', toastUngroup:'Les pages se déplacent maintenant une par une', toastJoin:'Joint au précédent',
      removedCount: n => plural(n,'1 page retirée',`${n} pages retirées`), removedPageNo: n => `Page ${n} retirée`, removedFile: n => `${n} retiré`,
      pages: n => plural(n,'1 page',`${n} pages`), pageNo: n => `p. ${n}`, sum:(p,f) => `<b>${p}</b> · ${plural(f,'1 fichier',f+' fichiers')}`,
      lockedWarn:'Les fichiers sans mot de passe seront ignorés', defaultName:'fusion', saved: n => `${n} enregistré`, saveFail:'Échec de l’enregistrement. Vérifiez vos fichiers.'
    },
    de: {
      brand:'Hapbon', sub:'PDF zusammenfügen', lead:'Ihre Dateien verlassen nie dieses Gerät', add:'Dateien hinzufügen', lang:'Sprache',
      emptyTitle:'PDFs oder Fotos hier ablegen', emptyTitleTouch:'Tippen, um PDFs oder Fotos auszuwählen',
      orClick:'Oder klicken zum Auswählen', formats:'PDF, Fotos (JPG, PNG, HEIC)', mix:'Alle Seiten aller Dateien beliebig anordnen',
      hint:'Zum Umsortieren ziehen. Mehrseitige PDFs bewegen sich als Stapel; aufklappen, um Seiten zu sehen und zu teilen.',
      hintTouch:'Gedrückt halten zum Ziehen. Mehrseitige PDFs zum Teilen aufklappen.',
      namePh:'Dateiname', nameAria:'Dateiname', save:'PDF speichern', saving:'Wird erstellt', undo:'Rückgängig',
      pwTitle:'Passwort eingeben', pwDesc:' ist passwortgeschützt. Geben Sie das Passwort ein, um die Datei entsperrt hinzuzufügen.', pwPh:'PDF-Passwort', later:'Später', ok:'OK',
      pwWrong:'Falsches Passwort. Bitte erneut versuchen.', unlocked:'Entsperrt',
      viewer:'Seitenvorschau', rotate:'Nach rechts drehen', close:'Schließen', prev:'Vorherige Seite', next:'Nächste Seite', dropHere:'Zum Hinzufügen ablegen',
      toDark:'Zum dunklen Modus wechseln', toLight:'Zum hellen Modus wechseln', theme:'Design wechseln',
      nothingUndo:'Nichts zum Rückgängigmachen', undone:'Rückgängig gemacht', onlyPdfImg:'Nur PDFs und Fotos möglich',
      badPhoto: n => `${n} kann in diesem Browser nicht geöffnet werden`,
      cantOpen:'Nicht lesbar', enterPw:'Passwort', removeFile:'Datei entfernen', andMore:(n,k) => `${n} und ${k} weitere`,
      expand:'Seiten aufklappen', removeGroup:'Diesen Stapel entfernen', removePage:'Diese Seite entfernen',
      jumpTitle:'Zu einer Seite in diesem Stapel', jumpLbl:'Gehe zu', jumpAria:'Seitenzahl',
      fold:'Zuklappen', foldTitle:'Wieder stapeln', split:'Gruppierung aufheben', splitTitle:'Seiten einzeln bewegen', join:'Mit vorherigem verbinden', joinTitle:'Mit dem vorherigen Stapel zusammenführen',
      scrollL:'Nach links scrollen', scrollR:'Nach rechts scrollen', cut:'Hier teilen',
      toastSplit:'Geteilt', toastUngroup:'Seiten lassen sich jetzt einzeln bewegen', toastJoin:'Mit vorherigem verbunden',
      removedCount: n => plural(n,'1 Seite entfernt',`${n} Seiten entfernt`), removedPageNo: n => `Seite ${n} entfernt`, removedFile: n => `${n} entfernt`,
      pages: n => plural(n,'1 Seite',`${n} Seiten`), pageNo: n => `S. ${n}`, sum:(p,f) => `<b>${p}</b> · ${plural(f,'1 Datei',f+' Dateien')}`,
      lockedWarn:'Dateien ohne Passwort werden übersprungen', defaultName:'zusammengefügt', saved: n => `${n} gespeichert`, saveFail:'Speichern fehlgeschlagen. Bitte Dateien prüfen.'
    }
  };
  function pickLang(){
    let saved = null; try { saved = localStorage.getItem('hapbon-lang'); } catch(e){}
    if (saved && I18N[saved]) return saved;
    for (const raw of (navigator.languages && navigator.languages.length ? navigator.languages : [navigator.language || 'en'])){
      const l = String(raw).toLowerCase();
      if (l.startsWith('zh')) return /tw|hk|mo|hant/.test(l) ? 'zh-TW' : 'zh-CN';
      const base = l.split('-')[0];
      if (I18N[base]) return base;
    }
    return 'en';
  }
  let LANG = pickLang();
  function t(key, ...args){ const v = (I18N[LANG] && I18N[LANG][key] !== undefined) ? I18N[LANG][key] : I18N.ko[key]; return typeof v === 'function' ? v(...args) : v; }
  const tr = t; window.__t = t;

  const $ = id => document.getElementById(id);
  // 라이트 / 다크 모드
  const root = document.documentElement, themeMeta = document.querySelector('meta[name="theme-color"]');
  function applyTheme(t, save){
    root.dataset.theme = t;
    themeMeta.content = t === 'dark' ? '#17171C' : '#F2F4F6';
    $('themeBtn').title = window.__t ? window.__t(t === 'dark' ? 'toLight' : 'toDark') : '';
    if (save){ try { localStorage.setItem('hapbon-theme', t); } catch(e){} }
  }
  applyTheme(root.dataset.theme || 'light', false);
  $('themeBtn').addEventListener('click', () => applyTheme(root.dataset.theme === 'dark' ? 'light' : 'dark', true));
  matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
    let saved = null; try { saved = localStorage.getItem('hapbon-theme'); } catch(err){}
    if (!saved) applyTheme(e.matches ? 'dark' : 'light', false);   // 직접 고른 적 없으면 기기 설정을 따라가기
  });
  const COLORS = ['#3182F6','#00B386','#FF8A00','#8B5CF6','#06B6D4','#F25291'];
  const files = new Map();   // fid -> {id,name,kind,bytes,mime,color,state:'ready'|'locked'|'error',raster,doc,numPages}
  let pages = [];            // {pid,fid,index,rot,thumb}
  let fseq = 0, pseq = 0, gseq = 0, colorIdx = 0, busy = false;
  const expanded = new Set();
  const stripPos = new Map();   // 펼친 묶음별 가로 스크롤 위치   // 펼쳐 놓은 묶음
  const ICON_EXPAND = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="7" height="16" rx="1.5"/><rect x="14" y="4" width="7" height="16" rx="1.5"/></svg>';
  const pwQueue = [];

  const ICON_ROT = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12a9 9 0 1 1-3-6.7L21 8"/><path d="M21 3v5h-5"/></svg>';
  const ICON_DEL = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 7h16M10 11v6M14 11v6M6 7l1 13h10l1-13M9 7V4h6v3"/></svg>';   // 빼기: 휴지통 (파일 이름표만 X)
  const ICON_X = '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round"><path d="M6 6l12 12M18 6L6 18"/></svg>';

  /* ---------- 되돌리기 기록 (Ctrl+Z / ⌘+Z) ---------- */
  const undoStack = [];
  const IS_MAC = /Mac|iPhone|iPad|iPod/.test(navigator.platform || navigator.userAgent);
  $('undoKey').textContent = IS_MAC ? '⌘Z' : 'Ctrl+Z';
  function pushUndo(fn){ undoStack.push(fn); if (undoStack.length > 50) undoStack.shift(); }
  function undoLast(){
    const fn = undoStack.pop();
    if (!fn){ toast(t('nothingUndo')); return; }
    fn(); toast(t('undone'));
  }
  document.addEventListener('keydown', e => {
    if (!(e.ctrlKey || e.metaKey) || e.shiftKey || e.altKey || e.key.toLowerCase() !== 'z') return;
    const t = e.target;
    if (t && (t.tagName === 'INPUT' || t.tagName === 'TEXTAREA' || t.isContentEditable)) return;   // 글자 입력 중엔 기본 동작
    if ($('scrim').classList.contains('show')) return;
    e.preventDefault(); undoLast();
  });

  /* ---------- 카드 테두리: 파일 색을 은은하게 ---------- */
  function tint(el, hex){
    const n = parseInt(hex.slice(1), 16), r = n >> 16, g = (n >> 8) & 255, b = n & 255;
    el.style.setProperty('--ring', `rgba(${r},${g},${b},.28)`);
    el.style.setProperty('--ring-h', `rgba(${r},${g},${b},.5)`);
  }

  /* ---------- toast ---------- */
  let toastTimer;
  function toast(msg, action){
    $('toastMsg').textContent = msg;
    if (action) pushUndo(action);
    const b = $('toastAct'); b.hidden = !action;
    b.onclick = action ? () => { const i = undoStack.lastIndexOf(action); if (i >= 0) undoStack.splice(i, 1); action(); hideToast(); } : null;
    $('toast').classList.add('show');
    clearTimeout(toastTimer); toastTimer = setTimeout(hideToast, action ? 5000 : 2500);
  }
  function hideToast(){ $('toast').classList.remove('show'); }

  /* ---------- loading files ---------- */
  async function openPdf(f, password){
    const doc = await pdfjsLib.getDocument({data: f.bytes.slice(), password: password || undefined, ...DOC_OPTS}).promise;
    f.doc = doc; f.numPages = doc.numPages; f.state = 'ready';
    try { await PDFLib.PDFDocument.load(f.bytes); f.raster = false; } catch(e){ f.raster = true; }
    const added = [];
    const gid = ++gseq;
    for (let i=0;i<doc.numPages;i++){ const p = {pid:++pseq, gid, fid:f.id, index:i, rot:0, thumb:null, fresh:true}; pages.push(p); added.push(p); }
    return added;
  }

  async function toJpeg(file){
    const url = URL.createObjectURL(file);
    try {
      const img = await new Promise((ok, no) => { const i = new Image(); i.onload = () => ok(i); i.onerror = no; i.src = url; });
      const c = document.createElement('canvas'); c.width = img.naturalWidth; c.height = img.naturalHeight;
      const ctx = c.getContext('2d'); ctx.fillStyle = '#fff'; ctx.fillRect(0,0,c.width,c.height); ctx.drawImage(img,0,0);
      const blob = await new Promise(r => c.toBlob(r, 'image/jpeg', .92));
      return new Uint8Array(await blob.arrayBuffer());
    } finally { URL.revokeObjectURL(url); }
  }

  async function addFiles(list){
    let firstAdd = true;
    for (const file of list){
      const isPdf = file.type === 'application/pdf' || /\.pdf$/i.test(file.name);
      const isImg = /^image\//.test(file.type) || /\.(jpe?g|png|heic|heif|webp|gif|bmp)$/i.test(file.name);
      if (!isPdf && !isImg){ toast(t('onlyPdfImg')); continue; }
      let bytes = new Uint8Array(await file.arrayBuffer()), mime = null;
      if (isImg){
        if (/^image\/png$/.test(file.type) || /\.png$/i.test(file.name)) mime = 'png';
        else if (/^image\/jpe?g$/.test(file.type) || /\.jpe?g$/i.test(file.name)) mime = 'jpg';
        else {
          try { bytes = await toJpeg(file); mime = 'jpg'; }
          catch(e){ toast(t('badPhoto', file.name)); continue; }
        }
      }
      const f = {id:++fseq, name:file.name, kind:isPdf?'pdf':'image', bytes, color:COLORS[colorIdx++ % COLORS.length], state:'ready'};
      files.set(f.id, f);
      if (isImg){
        f.mime = mime;
        f.numPages = 1;
        const p = {pid:++pseq, gid:++gseq, fid:f.id, index:0, rot:0, thumb:URL.createObjectURL(new Blob([f.bytes],{type:'image/'+(f.mime==='png'?'png':'jpeg')})), fresh:true};
        pages.push(p);
      } else {
        try { await openPdf(f); }
        catch(e){
          if (e && e.name === 'PasswordException'){ f.state = 'locked'; pwQueue.push(f.id); }
          else f.state = 'error';
        }
      }
      render();
    }
    nextPassword();
  }

  /* ---------- password modal ---------- */
  let pwFid = null;
  function nextPassword(){
    if (pwFid !== null) return;
    while (pwQueue.length){
      const id = pwQueue.shift(); const f = files.get(id);
      if (f && f.state === 'locked'){ askPassword(id); return; }
    }
  }
  function askPassword(id){
    pwFid = id; const f = files.get(id);
    $('pwName').textContent = f.name; $('pwInput').value = ''; $('pwErr').textContent = ''; $('pwField').classList.remove('err');
    $('scrim').classList.add('show'); setTimeout(() => $('pwInput').focus(), 50);
  }
  function closePassword(){ $('scrim').classList.remove('show'); pwFid = null; nextPassword(); }
  $('pwForm').addEventListener('submit', async e => {
    e.preventDefault();
    const f = files.get(pwFid); if (!f) return closePassword();
    try { await openPdf(f, $('pwInput').value); closePassword(); render(); toast(t('unlocked')); }
    catch(err){
      if (err && err.name === 'PasswordException'){ $('pwErr').textContent = t('pwWrong'); $('pwField').classList.add('err'); $('pwInput').select(); }
      else { f.state = 'error'; closePassword(); render(); }
    }
  });
  $('pwLater').addEventListener('click', closePassword);
  $('pwInput').addEventListener('input', () => { $('pwErr').textContent=''; $('pwField').classList.remove('err'); });
  document.addEventListener('keydown', e => { if (e.key === 'Escape' && pwFid !== null) closePassword(); });

  /* ---------- thumbnails ---------- */
  const thumbQueue = []; let thumbRunning = false;
  /* ---------- 제목 인식: 첫 페이지 위쪽에서 가장 큰 글씨 줄 ---------- */
  async function detectTitle(p){
    const f = files.get(p.fid);
    if (!f || f.kind !== 'pdf' || !f.doc) return null;
    const pg = await f.doc.getPage(p.index + 1);
    const vp = pg.getViewport({scale:1});
    const tc = await pg.getTextContent();
    const items = [];
    for (const it of tc.items){
      if (!it.str || !it.str.trim()) continue;
      const [x, y] = vp.convertToViewportPoint(it.transform[4], it.transform[5]);
      const size = Math.hypot(it.transform[2], it.transform[3]) || it.height;
      if (size < 4) continue;
      items.push({str: it.str, x, y, w: it.width, size});
    }
    if (!items.length) return null;
    // 같은 줄끼리 묶기 (y가 가깝고 글자 크기가 비슷하면 한 줄)
    items.sort((a,b) => a.y - b.y || a.x - b.x);
    const lines = [];
    for (const it of items){
      const L = lines.find(l => Math.abs(l.y - it.y) < Math.max(2, it.size * .35) && Math.abs(l.size - it.size) < it.size * .2);
      if (L) L.items.push(it); else lines.push({y: it.y, size: it.size, items: [it]});
    }
    for (const l of lines){
      l.items.sort((a,b) => a.x - b.x);
      let t = '', end = null;
      for (const it of l.items){
        if (end !== null && it.x - end > l.size * .25 && !t.endsWith(' ')) t += ' ';
        t += it.str; end = it.x + it.w;
      }
      l.text = t.replace(/\s+/g, ' ').trim();
      l.size = Math.max(...l.items.map(i => i.size));
    }
    // 본문 크기 = 글자 수 기준 중앙값 (글자가 많은 줄이 본문)
    const sizes = []; items.forEach(i => { const k = Math.min(200, Math.max(1, i.str.trim().length)); for (let j = 0; j < k; j++) sizes.push(i.size); });
    sizes.sort((a,b) => a-b); const median = sizes[Math.floor(sizes.length/2)];
    const cand = lines.filter(l => l.y < vp.height * .45 && l.text.replace(/[^\p{L}\p{N}]/gu, '').length >= 2);
    if (!cand.length) return null;
    cand.sort((a,b) => (b.size - a.size) || (a.y - b.y));
    const best = cand[0];
    if (best.size < median * 1.15) return null;      // 본문과 크기가 같으면 제목이 아니라고 봄
    let t = best.text.replace(/^[\[<(〈【]\s*(별지|별첨|붙임|서식)[^\]>)〉】]*[\]>)〉】]\s*/, '');
    const toks = t.split(' ');
    if (toks.length >= 3 && toks.every(x => [...x].length === 1)) t = toks.join('');   // "재 학 증 명 서" → "재학증명서"
    if (t.length > 60) t = t.slice(0, 60) + '…';
    return t || null;
  }
  const titleQueue = []; let titleRunning = false;
  function queueTitle(p){ if (p.title === undefined && !p.tq){ p.tq = true; titleQueue.push(p); runTitles(); } }
  async function runTitles(){
    if (titleRunning) return; titleRunning = true;
    while (titleQueue.length){
      const p = titleQueue.shift();
      try { p.title = await detectTitle(p); } catch(e){ p.title = null; }
      document.querySelectorAll(`.group[data-first="${p.pid}"]`).forEach(setHead);
    }
    titleRunning = false;
  }
  function setHead(box){
    const p = pages.find(x => x.pid === +box.dataset.first);
    const nm = box.querySelector('.hd-nm'), fn = box.querySelector('.hd-fn');
    if (p && p.title){ nm.textContent = p.title; nm.title = p.title; fn.textContent = box.dataset.fallback; }
    else { nm.textContent = box.dataset.fallback; nm.title = box.dataset.fallback; fn.textContent = ''; }
    if (p && p.title === undefined) queueTitle(p);
  }

  function queueThumb(p){ if (!p.thumb && !p.queued){ p.queued = true; thumbQueue.push(p); runThumbs(); } }
  async function runThumbs(){
    if (thumbRunning) return; thumbRunning = true;
    while (thumbQueue.length){
      const p = thumbQueue.shift(); const f = files.get(p.fid);
      if (!f || !f.doc) continue;
      try {
        const pg = await f.doc.getPage(p.index+1);
        const v1 = pg.getViewport({scale:1}); const vp = pg.getViewport({scale: 320 / Math.max(v1.width, v1.height)});
        const c = document.createElement('canvas'); c.width = Math.ceil(vp.width); c.height = Math.ceil(vp.height);
        const ctx = c.getContext('2d'); ctx.fillStyle='#fff'; ctx.fillRect(0,0,c.width,c.height);
        await pg.render({canvasContext:ctx, viewport:vp}).promise;
        p.thumb = c.toDataURL('image/jpeg', .85);
        document.querySelectorAll(`.thumb[data-tp="${p.pid}"]`).forEach(el => el.innerHTML = `<img alt="" src="${p.thumb}" style="transform:rotate(${p.rot}deg)">`);
      } catch(e){ console.error(e); }
    }
    thumbRunning = false;
  }

  /* ---------- render ---------- */
  function render(){
    // 보이는 파일 = 직접 빼지 않았고, 페이지가 남아 있거나 아직 열지 못한(암호/오류) 파일
    const visible = [...files.values()].filter(f => !f.removed && (f.state !== 'ready' || pages.some(p => p.fid === f.id)));
    visible.forEach((f, i) => f.color = COLORS[i % COLORS.length]);   // 남은 순서대로 색 다시 매기기
    const has = visible.length > 0 || pages.length > 0;
    $('empty').hidden = has; $('work').hidden = !has; $('addBtn').hidden = !has;
    $('bar').classList.toggle('show', has);

    // file chips
    const fc = $('files'); fc.innerHTML = '';
    for (const f of visible){
      const ch = document.createElement('div');
      ch.className = 'chip' + (f.state==='locked' ? ' locked' : f.state==='error' ? ' error' : '');
      const cnt = f.state==='ready' ? t('pages', pages.filter(p=>p.fid===f.id).length) : f.state==='locked' ? '' : t('cantOpen');
      ch.innerHTML = `<span class="dot" style="background:${f.color}"></span><span class="nm"></span><span class="ct">${cnt}</span>`
        + (f.state==='locked' ? `<button class="unlock">${t('enterPw')}</button>` : '')
        + `<button class="x" aria-label="${t('removeFile')}" title="${t('removeFile')}">${ICON_X}</button>`;
      ch.querySelector('.nm').textContent = f.name;
      ch.querySelector('.x').onclick = () => removeFile(f.id);
      const u = ch.querySelector('.unlock'); if (u) u.onclick = () => askPassword(f.id);
      fc.appendChild(ch);
    }

    // groups (연속된 같은 gid = 한 묶음)
    const grid = $('grid');
    // 다시 그려도 펼친 스트립의 보던 위치 유지
    grid.querySelectorAll('.group:not(.stack)').forEach(el => { const b = el.querySelector('.g-body'); if (b) stripPos.set(+el.dataset.gid, b.scrollLeft); });
    grid.innerHTML = '';
    const groups = [];
    pages.forEach(p => { const g = groups[groups.length-1]; if (g && g.gid === p.gid) g.items.push(p); else groups.push({gid:p.gid, items:[p]}); });
    let n = 0, stagger = 0;
    groups.forEach((g, gi) => {
      const fids = [...new Set(g.items.map(p => p.fid))];
      const f0 = files.get(fids[0]);
      if (!(expanded.has(g.gid) && g.items.length > 1)){
        const p = g.items[0], cnt = g.items.length, start = n + 1; n += cnt;
        const box = document.createElement('div'); box.className = 'group stack'; box.dataset.gid = g.gid; tint(box, f0.color);
        if (g.items.some(x => x.fresh)){ box.classList.add('enter'); box.style.animationDelay = Math.min(stagger++, 8) * 40 + 'ms'; }
        g.items.forEach(x => { x.fresh = false; if (!x.thumb) queueThumb(x); });
        const r = ((p.rot % 360) + 360) % 360, layers = Math.min(cnt, 3);
        const title = fids.length === 1 ? f0.name : t('andMore', f0.name, fids.length-1);
        box.innerHTML = `<div class="sheets n${layers}">
            ${layers >= 3 ? '<div class="sheet s3"></div>' : ''}${layers >= 2 ? '<div class="sheet s2"></div>' : ''}
            <div class="thumb rot${r}" data-tp="${p.pid}">${p.thumb ? `<img alt="" src="${p.thumb}" style="transform:rotate(${p.rot}deg)">` : '<div class="skeleton"></div>'}</div>
          </div>
          <div class="acts">
            ${cnt > 1 ? `<button class="act" data-a="expand" title="${t('expand')}" aria-label="${t('expand')}">${ICON_EXPAND}</button>`
                      : `<button class="act" data-a="rot" title="${t('rotate')}" aria-label="${t('rotate')}">${ICON_ROT}</button>`}
            <button class="act del" data-a="del" title="${t(cnt > 1 ? 'removeGroup' : 'removePage')}" aria-label="${t(cnt > 1 ? 'removeGroup' : 'removePage')}">${ICON_DEL}</button>
          </div>
          <div class="c-title hd-nm"></div>
          <div class="c-meta"><span class="badge">${cnt > 1 ? start + '–' + n : start}</span><span class="dot" style="background:${f0.color}"></span><span class="hd-fn"></span><span class="ct">${t('pages', cnt)}</span></div>`;
        box.dataset.first = p.pid; box.dataset.fallback = title; setHead(box);
        const ex = box.querySelector('[data-a=expand]'); if (ex) ex.onclick = () => {
          expanded.clear(); expanded.add(g.gid); render();   // 한 번에 하나만 펼치기
          const el = document.querySelector(`#grid > .group[data-gid="${g.gid}"]`); if (el) el.scrollIntoView({block:'nearest', behavior:'smooth'});
        };
        const ro = box.querySelector('[data-a=rot]'); if (ro) ro.onclick = () => rotate(p.pid);
        box.querySelector('[data-a=del]').onclick = () => cnt > 1 ? removeGroup(g.gid) : removePage(p.pid);
        box.querySelector('.thumb').onclick = () => openViewer(p.pid);
        grid.appendChild(box);
        return;
      }
      const box = document.createElement('div'); box.className = 'group'; box.dataset.gid = g.gid; tint(box, f0.color);
      if (g.items.some(p => p.fresh)){ box.classList.add('enter'); box.style.animationDelay = Math.min(stagger++, 8) * 40 + 'ms'; }
      const title = fids.length === 1 ? f0.name : t('andMore', f0.name, fids.length-1);
      box.innerHTML = `<div class="g-head"><span class="dot" style="background:${f0.color}"></span><span class="nm hd-nm"></span><span class="fn hd-fn"></span><span class="ct">${t('pages', g.items.length)}</span><span class="sp"></span>
          ${g.items.length > 8 ? `<label class="jump" title="${t('jumpTitle')}"><span class="lbl">${t('jumpLbl')}</span><input type="number" min="1" max="${g.items.length}" inputmode="numeric" aria-label="${t('jumpAria')}"><span>/ ${g.items.length}</span></label>` : ''}
          <button class="g-btn" data-a="fold" title="${t('foldTitle')}">${t('fold')}</button>
          ${g.items.length > 1 ? `<button class="g-btn" data-a="split" title="${t('splitTitle')}">${t('split')}</button>` : ''}
          ${gi > 0 ? `<button class="g-btn" data-a="join" title="${t('joinTitle')}">${t('join')}</button>` : ''}
          <button class="g-btn x" data-a="rmg" title="${t('removeGroup')}" aria-label="${t('removeGroup')}">${ICON_DEL}</button></div>
        <div class="g-wrap"><div class="fade l"></div><div class="fade r"></div>
          <button class="scroll-btn l" aria-label="${t('scrollL')}"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M15 6l-6 6 6 6"/></svg></button>
          <button class="scroll-btn r" aria-label="${t('scrollR')}"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M9 6l6 6-6 6"/></svg></button>
          <div class="g-body"></div></div>
        <div class="track" hidden><div class="thumbbar"></div></div>`;
      box.dataset.first = g.items[0].pid; box.dataset.fallback = title;
      setHead(box);
      box.querySelector('[data-a=fold]').onclick = () => { expanded.delete(g.gid); render(); };
      const sb = box.querySelector('[data-a=split]'); if (sb) sb.onclick = () => ungroup(g.gid);
      const jb = box.querySelector('[data-a=join]'); if (jb) jb.onclick = () => joinPrev(g.gid);
      box.querySelector('[data-a=rmg]').onclick = () => removeGroup(g.gid);
      const body = box.querySelector('.g-body');
      g.items.forEach((p, k) => {
        n++;
        const f = files.get(p.fid);
        const el = document.createElement('div'); el.className = 'page'; el.dataset.pid = p.pid; p.fresh = false;
        const r = ((p.rot % 360) + 360) % 360;
        el.innerHTML = `${k > 0 ? `<button class="cut" title="${t('cut')}" aria-label="${t('cut')}">${ICON_CUT}</button>` : ''}
          <div class="thumb rot${r}" data-tp="${p.pid}">${p.thumb ? `<img alt="" src="${p.thumb}" style="transform:rotate(${p.rot}deg)">` : '<div class="skeleton"></div>'}</div>
          <div class="acts">
            <button class="act" data-a="rot" title="${t('rotate')}" aria-label="${t('rotate')}">${ICON_ROT}</button>
            <button class="act del" data-a="del" title="${t('removePage')}" aria-label="${t('removePage')}">${ICON_DEL}</button>
          </div>
          <div class="cap"><span class="badge">${n}</span><span class="nm">${f.numPages>1 ? t('pageNo', p.index+1) : ''}</span></div>`;
        if (fids.length > 1) el.querySelector('.cap .nm').textContent = f.name.replace(/\.[^.]+$/, '') + (f.numPages>1 ? ' · ' + t('pageNo', p.index+1) : '');
        el.querySelector('[data-a=rot]').onclick = () => rotate(p.pid);
        el.querySelector('[data-a=del]').onclick = () => removePage(p.pid);
        el.querySelector('.thumb').onclick = () => openViewer(p.pid);
        const cut = el.querySelector('.cut'); if (cut) cut.onclick = () => splitAt(p.pid);
        body.appendChild(el);
        if (!p.thumb) queueThumb(p);
      });
      grid.appendChild(box);
      setupStrip(box);
    });
    updateBar();
  }

  const ICON_CUT = '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="6" cy="6" r="3"/><circle cx="6" cy="18" r="3"/><path d="M20 4L8.1 15.9M14.5 14.5L20 20M8.1 8.1L12 12"/></svg>';

  /* ---------- 펼친 묶음: 가로 스트립 + 직접 그린 스크롤바 + 쪽 이동 ---------- */
  function setupStrip(box){
    const wrap = box.querySelector('.g-wrap'), body = box.querySelector('.g-body');
    const track = box.querySelector('.track'), bar = track.querySelector('.thumbbar');
    const upd = () => {
      const max = body.scrollWidth - body.clientWidth;
      wrap.classList.toggle('can-l', body.scrollLeft > 2);
      wrap.classList.toggle('can-r', body.scrollLeft < max - 2);
      track.hidden = max <= 2;
      if (max > 2){
        const tw = track.clientWidth, bw = Math.max(40, tw * body.clientWidth / body.scrollWidth);
        bar.style.width = bw + 'px'; bar.style.transform = `translateX(${(tw - bw) * body.scrollLeft / max}px)`;
      }
    };
    body.addEventListener('scroll', upd, {passive:true});
    new ResizeObserver(upd).observe(body);
    const step = () => Math.max(body.clientWidth * .8, 150);
    box.querySelector('.scroll-btn.l').onclick = () => body.scrollBy({left: -step(), behavior:'smooth'});
    box.querySelector('.scroll-btn.r').onclick = () => body.scrollBy({left: step(), behavior:'smooth'});
    // 세로 휠 → 가로 (끝에 닿으면 페이지 스크롤로 넘김)
    body.addEventListener('wheel', e => {
      if (Math.abs(e.deltaX) > Math.abs(e.deltaY) || e.ctrlKey) return;
      const max = body.scrollWidth - body.clientWidth; if (max <= 0) return;
      if ((e.deltaY < 0 && body.scrollLeft <= 0) || (e.deltaY > 0 && body.scrollLeft >= max - 1)) return;
      e.preventDefault(); body.scrollLeft = Math.max(0, Math.min(max, body.scrollLeft + e.deltaY));
    }, {passive:false});
    // 스크롤바 끌기 / 빈 곳 클릭
    const toScroll = x => { const tw = track.clientWidth, bw = bar.offsetWidth, max = body.scrollWidth - body.clientWidth;
      body.scrollLeft = Math.max(0, Math.min(1, x / (tw - bw))) * max; };
    track.addEventListener('pointerdown', e => {
      e.preventDefault(); e.stopPropagation();
      const r = track.getBoundingClientRect(), bx = new DOMMatrix(getComputedStyle(bar).transform).m41;
      const onBar = e.target === bar; const grab = onBar ? e.clientX - r.left - bx : bar.offsetWidth / 2;
      if (!onBar) toScroll(e.clientX - r.left - grab);
      track.classList.add('drag'); track.setPointerCapture(e.pointerId);
      const mv = ev => toScroll(ev.clientX - r.left - grab);
      const up = () => { track.classList.remove('drag'); track.removeEventListener('pointermove', mv); track.removeEventListener('pointerup', up); track.removeEventListener('pointercancel', up); };
      track.addEventListener('pointermove', mv); track.addEventListener('pointerup', up); track.addEventListener('pointercancel', up);
    });
    // 쪽 번호로 이동
    const jump = box.querySelector('.jump input');
    if (jump){
      const go = () => {
        const n = Math.round(+jump.value); const els = body.querySelectorAll('.page');
        if (!n || n < 1 || n > els.length){ jump.select(); return; }
        const el = els[n-1];
        body.scrollTo({left: el.offsetLeft - (body.clientWidth - el.offsetWidth) / 2, behavior:'smooth'});
        el.classList.remove('flash'); void el.offsetWidth; el.classList.add('flash');
      };
      jump.addEventListener('keydown', e => { if (e.key === 'Enter'){ e.preventDefault(); go(); } });
      jump.addEventListener('change', go);
      ['pointerdown','mousedown','touchstart'].forEach(t => jump.addEventListener(t, e => e.stopPropagation()));
    }
    const keep = stripPos.get(+box.dataset.gid);
    if (keep) body.scrollLeft = keep;
    requestAnimationFrame(upd);
  }

  /* ---------- 묶음 ---------- */
  function snapshot(){ return pages.map(p => ({...p})); }
  function restore(snap){ pages = snap.map(p => ({...p, fresh:false})); render(); }
  function splitAt(pid){
    const snap = snapshot();
    const i = pages.findIndex(x => x.pid === pid), gid = pages[i].gid, ng = ++gseq;
    for (let k = i; k < pages.length && pages[k].gid === gid; k++) pages[k].gid = ng;
    if (expanded.has(gid)) expanded.add(ng);
    render(); toast(t('toastSplit'), () => restore(snap));
  }
  function ungroup(gid){
    const snap = snapshot();
    pages.forEach(p => { if (p.gid === gid) p.gid = ++gseq; });
    render(); toast(t('toastUngroup'), () => restore(snap));
  }
  function joinPrev(gid){
    const snap = snapshot();
    const i = pages.findIndex(x => x.gid === gid); if (i <= 0) return;
    const prev = pages[i-1].gid;
    pages.forEach(p => { if (p.gid === gid) p.gid = prev; });
    if (expanded.has(gid)) expanded.add(prev);
    render(); toast(t('toastJoin'), () => restore(snap));
  }
  function removeGroup(gid){
    const snap = snapshot();
    const cnt = pages.filter(p => p.gid === gid).length;
    pages = pages.filter(p => p.gid !== gid);
    render(); removedCleanup(); toast(t('removedCount', cnt), () => restore(snap));
  }

  function updateBar(){
    const ready = [...files.values()].filter(f => !f.removed && f.state==='ready' && pages.some(p => p.fid === f.id)).length;
    $('sum').innerHTML = t('sum', t('pages', pages.length), ready);
    const locked = [...files.values()].some(f => !f.removed && f.state==='locked');
    $('warn').hidden = !locked; $('warn').textContent = locked ? t('lockedWarn') : '';
    if (!busy) $('saveBtn').disabled = pages.length === 0;
  }

  /* ---------- actions ---------- */
  function rotate(pid, delta = 90, record = true){
    const p = pages.find(x=>x.pid===pid); if (!p) return;
    p.rot = p.rot + delta;
    if (record) pushUndo(() => rotate(pid, -delta, false));
    document.querySelectorAll(`.thumb[data-tp="${pid}"]`).forEach(th => {
      th.className = 'thumb rot' + (((p.rot % 360) + 360) % 360);
      const img = th.querySelector('img'); if (img) img.style.transform = `rotate(${p.rot}deg)`;
    });
    if (vPid === pid) showViewer();
  }
  function removePage(pid){
    const snap = snapshot();
    const i = pages.findIndex(x=>x.pid===pid); pages.splice(i,1);
    render(); removedCleanup();
    toast(t('removedPageNo', i+1), () => restore(snap));
  }
  function removeFile(fid){
    const f = files.get(fid);
    const snap = snapshot();
    pages = pages.filter(p=>p.fid!==fid); f.removed = true;
    render(); removedCleanup();
    toast(t('removedFile', f.name), () => { f.removed = false; restore(snap); });
  }

  /* ---------- viewer ---------- */
  let vPid = null; const bigCache = new Map();
  async function bigImage(p){
    const f = files.get(p.fid);
    if (f.kind === 'image') return p.thumb;
    if (bigCache.has(p.pid)) return bigCache.get(p.pid);
    const pg = await f.doc.getPage(p.index+1);
    const v1 = pg.getViewport({scale:1});
    const target = Math.min(2200, Math.max(window.innerWidth, window.innerHeight) * Math.min(window.devicePixelRatio || 1, 2));
    const vp = pg.getViewport({scale: target / Math.max(v1.width, v1.height)});
    const c = document.createElement('canvas'); c.width = Math.ceil(vp.width); c.height = Math.ceil(vp.height);
    const ctx = c.getContext('2d'); ctx.fillStyle='#fff'; ctx.fillRect(0,0,c.width,c.height);
    await pg.render({canvasContext:ctx, viewport:vp}).promise;
    const url = c.toDataURL('image/jpeg', .9); bigCache.set(p.pid, url); return url;
  }
  function openViewer(pid){ vPid = pid; $('viewer').classList.add('show'); document.body.style.overflow = 'hidden'; showViewer(); }
  function closeViewer(){ vPid = null; $('viewer').classList.remove('show'); document.body.style.overflow = ''; }
  async function showViewer(){
    const i = pages.findIndex(x => x.pid === vPid); if (i < 0) return closeViewer();
    const p = pages[i], f = files.get(p.fid);
    $('vNum').textContent = `${i+1} / ${pages.length}`;
    const gFirst = pages.find(x => x.gid === p.gid);
    $('vName').textContent = (gFirst && gFirst.title ? gFirst.title + ' · ' : '') + f.name + (f.numPages > 1 ? ' · ' + t('pageNo', p.index+1) : '');
    $('vPrev').disabled = i === 0; $('vNext').disabled = i === pages.length - 1;
    const stage = $('vStage');
    const fit = () => { const im = stage.querySelector('img'); if (!im) return;
      const r = ((p.rot % 360) + 360) % 360, side = r === 90 || r === 270;
      const W = stage.clientWidth, H = stage.clientHeight, w = im.naturalWidth, h = im.naturalHeight;
      const s = side ? Math.min(W / h, H / w) : Math.min(W / w, H / h);
      im.style.maxWidth = 'none'; im.style.maxHeight = 'none';
      im.style.width = (w * s) + 'px'; im.style.height = (h * s) + 'px';
      im.style.transform = `translate(-50%,-50%) rotate(${p.rot}deg)`; };
    const cur = stage.querySelector('img');
    if (cur && cur.dataset.pid == p.pid){ fit(); return; }
    if (p.thumb){ stage.innerHTML = `<img alt="" data-pid="${p.pid}" src="${p.thumb}">`; stage.querySelector('img').onload = fit; }
    else stage.innerHTML = '<div class="skeleton"></div>';
    try {
      const url = await bigImage(p);
      if (vPid !== p.pid) return;
      const im = new Image(); im.alt = ''; im.dataset.pid = p.pid; im.onload = () => { stage.innerHTML = ''; stage.appendChild(im); fit(); }; im.src = url;
    } catch(e){ console.error(e); }
    window.__fitViewer = fit;
  }
  function stepViewer(d){ const i = pages.findIndex(x => x.pid === vPid) + d; if (i >= 0 && i < pages.length){ vPid = pages[i].pid; showViewer(); } }
  $('vClose').onclick = closeViewer;
  $('vPrev').onclick = () => stepViewer(-1);
  $('vNext').onclick = () => stepViewer(1);
  $('vRot').onclick = () => rotate(vPid);
  $('viewer').addEventListener('click', e => { if (e.target.id === 'viewer' || e.target.id === 'vStage') closeViewer(); });
  window.addEventListener('resize', () => { if (vPid !== null && window.__fitViewer) window.__fitViewer(); });
  document.addEventListener('keydown', e => {
    if (vPid === null) return;
    if (e.key === 'Escape') closeViewer();
    else if (e.key === 'ArrowLeft') stepViewer(-1);
    else if (e.key === 'ArrowRight') stepViewer(1);
  });
  // 휴대폰: 좌우로 밀어서 넘기기
  let tx = null;
  $('vStage').addEventListener('touchstart', e => { tx = e.touches.length === 1 ? e.touches[0].clientX : null; }, {passive:true});
  $('vStage').addEventListener('touchend', e => { if (tx === null) return; const dx = e.changedTouches[0].clientX - tx; if (Math.abs(dx) > 50) stepViewer(dx < 0 ? 1 : -1); tx = null; });

  let dragSnap = null;
  new Sortable($('grid'), {
    animation: 220, easing: 'cubic-bezier(.2,.8,.2,1)',
    delay: 200, delayOnTouchOnly: true, touchStartThreshold: 6,
    ghostClass: 'ghost', chosenClass: 'chosen', filter: '.act,.g-btn,.cut,.scroll-btn,.track,.jump', preventOnFilter: false,
    onStart(){ dragSnap = snapshot(); },
    onEnd(ev){
      if (ev.oldIndex !== ev.newIndex && dragSnap){ const snap = dragSnap; pushUndo(() => restore(snap)); }
      dragSnap = null;
      const order = [...$('grid').children].map(el => +el.dataset.gid);
      const idx = new Map(pages.map((p,i) => [p.pid, i]));
      pages.sort((a,b) => (order.indexOf(a.gid) - order.indexOf(b.gid)) || (idx.get(a.pid) - idx.get(b.pid)));
      render();
    }
  });

  /* ---------- save ---------- */
  const A4 = [595.28, 841.89];
  async function build(progress){
    const {PDFDocument, degrees} = PDFLib;
    const out = await PDFDocument.create();
    const srcCache = new Map(), imgCache = new Map();
    let n = 0;
    for (const p of pages){
      progress(++n, pages.length);
      const f = files.get(p.fid);
      const rot = ((p.rot % 360) + 360) % 360;
      if (f.kind === 'image'){
        let img = imgCache.get(f.id);
        if (!img){ img = f.mime==='png' ? await out.embedPng(f.bytes) : await out.embedJpg(f.bytes); imgCache.set(f.id, img); }
        const [W,H] = A4, m = 28, s = Math.min((W-2*m)/img.width, (H-2*m)/img.height);
        const page = out.addPage([W,H]);
        page.drawImage(img, {x:(W-img.width*s)/2, y:(H-img.height*s)/2, width:img.width*s, height:img.height*s});
        if (rot) page.setRotation(degrees(rot));
      } else if (f.raster){
        const pg = await f.doc.getPage(p.index+1);
        const base = pg.getViewport({scale:1}), vp = pg.getViewport({scale:200/72});
        const c = document.createElement('canvas'); c.width = Math.ceil(vp.width); c.height = Math.ceil(vp.height);
        const ctx = c.getContext('2d'); ctx.fillStyle='#fff'; ctx.fillRect(0,0,c.width,c.height);
        await pg.render({canvasContext:ctx, viewport:vp}).promise;
        const jpg = await new Promise(r => c.toBlob(b => b.arrayBuffer().then(r), 'image/jpeg', .92));
        const img = await out.embedJpg(jpg);
        const page = out.addPage([base.width, base.height]);
        page.drawImage(img, {x:0, y:0, width:base.width, height:base.height});
        if (rot) page.setRotation(degrees(rot));
      } else {
        let src = srcCache.get(f.id);
        if (!src){ src = await PDFDocument.load(f.bytes); srcCache.set(f.id, src); }
        const [cp] = await out.copyPages(src, [p.index]);
        if (rot) cp.setRotation(degrees((cp.getRotation().angle + rot) % 360));
        out.addPage(cp);
      }
    }
    return out.save();
  }

  function removedCleanup(){ if (vPid !== null && !pages.some(x => x.pid === vPid)) closeViewer(); }
  $('saveBtn').addEventListener('click', async () => {
    if (busy || !pages.length) return;
    busy = true; const btn = $('saveBtn'); btn.disabled = true;
    btn.innerHTML = `<span class="spin"></span><span id="prog">${t('saving')}</span>`;
    try {
      const bytes = await build((i,t) => { const el = $('prog'); if (el) el.textContent = `${i} / ${t}`; });
      const d = new Date(), pad = x => String(x).padStart(2,'0');
      const today = `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}`;
      let name = ($('outname').value.trim().replace(/\.pdf$/i,'').replace(/[\\/:*?"<>|]/g,'_') || `${tr('defaultName')}_${today}`) + '.pdf';
      const a = document.createElement('a');
      a.href = URL.createObjectURL(new Blob([bytes], {type:'application/pdf'})); a.download = name;
      document.body.appendChild(a); a.click(); a.remove();
      setTimeout(() => URL.revokeObjectURL(a.href), 60000);
      window.__lastBytes = bytes;
      toast(tr('saved', name));
    } catch(e){ console.error(e); toast(tr('saveFail')); }
    busy = false; btn.textContent = tr('save'); updateBar();
  });

  /* ---------- input ---------- */
  const picker = $('picker');
  $('empty').addEventListener('click', () => picker.click());
  $('empty').addEventListener('keydown', e => { if (e.key==='Enter'||e.key===' '){ e.preventDefault(); picker.click(); }});
  $('addBtn').addEventListener('click', () => picker.click());
  picker.addEventListener('change', () => { addFiles([...picker.files]); picker.value=''; });
  let dragDepth = 0;
  const isFiles = e => e.dataTransfer && [...e.dataTransfer.types].includes('Files');
  window.addEventListener('dragenter', e => { if (isFiles(e)){ dragDepth++; $('dropOv').classList.add('show'); }});
  window.addEventListener('dragleave', e => { if (isFiles(e) && --dragDepth <= 0){ dragDepth=0; $('dropOv').classList.remove('show'); }});
  window.addEventListener('dragover', e => { if (isFiles(e)) e.preventDefault(); });
  window.addEventListener('drop', e => { if (!isFiles(e)) return; e.preventDefault(); dragDepth=0; $('dropOv').classList.remove('show'); addFiles([...e.dataTransfer.files]); });

  // test hooks
  /* ---------- 언어 적용 ---------- */
  const IS_TOUCH = matchMedia('(hover:none)').matches;
  function applyLang(l, save){
    LANG = I18N[l] ? l : 'en';
    document.documentElement.lang = LANG;
    document.title = `${t('brand')} - ${t('sub')}`;
    document.querySelectorAll('[data-i18n]').forEach(el => { if (el.id === 'saveBtn' && busy) return; el.textContent = t(el.dataset.i18n); });
    document.querySelectorAll('[data-i18n-ph]').forEach(el => el.placeholder = t(el.dataset.i18nPh));
    document.querySelectorAll('[data-i18n-aria]').forEach(el => el.setAttribute('aria-label', t(el.dataset.i18nAria)));
    document.querySelectorAll('[data-i18n-title]').forEach(el => { const [k, suf] = el.dataset.i18nTitle.split('|'); el.title = t(k) + (suf ? ' ' + suf : ''); });
    $('emptyTitle').textContent = t(IS_TOUCH ? 'emptyTitleTouch' : 'emptyTitle');
    document.querySelector('.empty p').innerHTML = (IS_TOUCH ? '' : t('orClick') + ' · ') + t('formats') + '<br>' + t('mix');
    $('hint').textContent = t(IS_TOUCH ? 'hintTouch' : 'hint');
    applyTheme(root.dataset.theme || 'light', false);
    $('langCur').textContent = LANGS.find(x => x[0] === LANG)[1];
    $('langMenu').querySelectorAll('li').forEach(li => li.setAttribute('aria-selected', li.dataset.code === LANG ? 'true' : 'false'));
    if (save){ try { localStorage.setItem('hapbon-lang', LANG); } catch(e){} }
    render();
  }
  // 언어 드롭다운
  const CHECK = '<svg class="ck" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12.5l4.5 4.5L19 7.5"/></svg>';
  const langBtn = $('langBtn'), langMenu = $('langMenu');
  langMenu.innerHTML = LANGS.map(([code, name, en]) =>
    `<li role="option" tabindex="-1" data-code="${code}" lang="${code}" aria-selected="false">${CHECK}<span>${name}</span>${en !== name ? `<span class="en">${en}</span>` : ''}</li>`).join('');
  const items = () => [...langMenu.querySelectorAll('li')];
  function openLang(focusCurrent){
    langMenu.hidden = false; langBtn.setAttribute('aria-expanded', 'true');
    const cur = items().find(li => li.dataset.code === LANG) || items()[0];
    if (focusCurrent) cur.focus();
  }
  function closeLang(refocus){
    if (langMenu.hidden) return;
    langMenu.hidden = true; langBtn.setAttribute('aria-expanded', 'false');
    if (refocus) langBtn.focus();
  }
  langBtn.addEventListener('click', () => langMenu.hidden ? openLang(false) : closeLang(false));
  langBtn.addEventListener('keydown', e => { if (['ArrowDown','ArrowUp','Enter',' '].includes(e.key)){ e.preventDefault(); openLang(true); } });
  langMenu.addEventListener('click', e => { const li = e.target.closest('li'); if (!li) return; applyLang(li.dataset.code, true); closeLang(true); });
  langMenu.addEventListener('keydown', e => {
    const list = items(), i = list.indexOf(document.activeElement);
    if (e.key === 'ArrowDown'){ e.preventDefault(); list[(i + 1) % list.length].focus(); }
    else if (e.key === 'ArrowUp'){ e.preventDefault(); list[(i - 1 + list.length) % list.length].focus(); }
    else if (e.key === 'Home'){ e.preventDefault(); list[0].focus(); }
    else if (e.key === 'End'){ e.preventDefault(); list[list.length - 1].focus(); }
    else if (e.key === 'Enter' || e.key === ' '){ e.preventDefault(); if (i >= 0){ applyLang(list[i].dataset.code, true); closeLang(true); } }
    else if (e.key === 'Escape'){ e.preventDefault(); closeLang(true); }
    else if (e.key === 'Tab'){ closeLang(false); }
  });
  document.addEventListener('pointerdown', e => { if (!$('langBox').contains(e.target)) closeLang(false); });
  applyLang(LANG, false);

  window.__app = { addFiles, get pages(){ return pages; }, files, move(from,to){ const [p]=pages.splice(from,1); pages.splice(to,0,p); render(); } };
  window.__app.openViewer = openViewer;
  render();
})();
</script>
</body>
</html>
