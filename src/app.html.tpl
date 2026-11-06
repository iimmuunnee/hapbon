<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#F2F4F6">
<title>PDF 합치기</title>
<style>
  :root{
    --bg:#F2F4F6; --card:#FFFFFF; --ink:#191F28; --sub:#4E5968; --muted:#8B95A1; --line:#E5E8EB; --fill:#F9FAFB;
    --primary:#3182F6; --primary-press:#1B64DA; --primary-soft:#E8F3FF; --danger:#F04452;
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
  h1{font-size:26px;font-weight:700;margin:0 0 6px}
  .lead{margin:0;color:var(--sub);font-size:15px;display:flex;align-items:center;gap:6px}
  .lead svg{color:var(--primary);flex:none}
  .btn{height:44px;padding:0 18px;border-radius:12px;font-size:15px;font-weight:600;display:inline-flex;align-items:center;gap:6px;transition:background .15s var(--ease),transform .1s var(--ease)}
  .btn:active:not(:disabled){transform:scale(.97)}
  .btn-secondary{background:var(--primary-soft);color:var(--primary)}
  .btn-secondary:hover{background:#D6E9FF}
  .btn-primary{background:var(--primary);color:#fff;min-width:148px;justify-content:center}
  .btn-primary:hover:not(:disabled){background:var(--primary-press)}
  .btn-primary:disabled{background:#B9D7FC}

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
  .chip .x:hover{background:#FFEEEE;color:var(--danger)}
  .chip.locked{background:#FFF4E6;color:#B25E09}
  .chip.locked .unlock{font-weight:600;color:#B25E09;text-decoration:underline;text-underline-offset:2px;padding:0 4px}
  .chip.error{background:#FFEEEE;color:var(--danger)}

  /* page grid */
  .hint{font-size:13px;color:var(--muted);margin:0 0 12px}
  .grid{position:relative;z-index:0;isolation:isolate;display:flex;flex-wrap:wrap;gap:16px;align-items:flex-start}
  .group{background:var(--card);border-radius:20px;padding:12px;cursor:grab;user-select:none;max-width:100%;transition:box-shadow .2s var(--ease);box-shadow:0 0 0 1.5px var(--ring,transparent)}
  .group:hover{box-shadow:0 0 0 1.5px var(--ring-h,transparent),0 4px 16px rgba(0,27,55,.08)}
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
  .g-btn.x{width:28px;padding:0;display:grid;place-items:center;color:var(--danger);background:#FFF5F5}
  .g-btn.x:hover{background:#FFE3E3;color:var(--danger)}
  .group:hover .g-btn,.group:focus-within .g-btn{opacity:1}
  .group:not(.stack){flex:1 1 100%;min-width:0}
  .g-wrap{position:relative}
  .g-body{display:flex;flex-wrap:nowrap;gap:22px;overflow-x:auto;overscroll-behavior-x:contain;padding:4px 14px 8px;margin:0 -12px;scrollbar-width:none}
  .g-body::-webkit-scrollbar{display:none}
  .g-body .page{width:128px;cursor:grab}
  .g-body .thumb{background:#fff;box-shadow:0 0 0 1px var(--line)}
  .g-body .thumb img{box-shadow:none}
  .g-body .cut{left:-11px;margin-left:-12px}
  .page.flash .thumb{animation:flash 1.4s var(--ease)}
  @keyframes flash{0%,60%{box-shadow:0 0 0 3px var(--primary)}100%{box-shadow:0 0 0 1px var(--line)}}
  .fade{position:absolute;top:0;bottom:0;width:56px;pointer-events:none;opacity:0;transition:opacity .2s var(--ease);z-index:3}
  .fade.l{left:-12px;background:linear-gradient(90deg,#fff 30%,rgba(255,255,255,0))}
  .fade.r{right:-12px;background:linear-gradient(270deg,#fff 30%,rgba(255,255,255,0))}
  .g-wrap.can-l .fade.l,.g-wrap.can-r .fade.r{opacity:1}
  .scroll-btn{position:absolute;top:calc(50% - 32px);width:36px;height:36px;border-radius:50%;background:#fff;box-shadow:0 2px 8px rgba(0,27,55,.16);display:grid;place-items:center;color:var(--sub);z-index:4;opacity:0;pointer-events:none;transition:opacity .2s var(--ease)}
  .scroll-btn:hover{color:var(--ink)}
  .scroll-btn.l{left:-4px} .scroll-btn.r{right:-4px}
  .g-wrap.can-l .scroll-btn.l,.g-wrap.can-r .scroll-btn.r{opacity:1;pointer-events:auto}
  .track{position:relative;height:6px;border-radius:6px;background:var(--fill);margin:6px 2px 0;cursor:pointer;touch-action:none}
  .track[hidden]{display:none}
  .track .thumbbar{position:absolute;top:0;bottom:0;left:0;border-radius:6px;background:#C5CCD3;cursor:grab;transition:background .15s}
  .track:hover .thumbbar,.track.drag .thumbbar{background:#8B95A1}
  .track.drag .thumbbar{cursor:grabbing}
  .track::before{content:'';position:absolute;inset:-8px 0}
  .jump{display:flex;align-items:center;gap:6px;height:28px;padding:0 4px 0 10px;border-radius:8px;background:var(--fill);font-size:12px;color:var(--muted);flex:none}
  .jump input{width:38px;height:22px;border:1px solid var(--line);border-radius:6px;background:#fff;text-align:center;font:inherit;font-size:12px;color:var(--ink);outline:none;-moz-appearance:textfield}
  .jump input:focus{border-color:var(--primary)}
  .jump input::-webkit-outer-spin-button,.jump input::-webkit-inner-spin-button{-webkit-appearance:none;margin:0}
  .group.stack{width:180px;padding:12px;position:relative}
  .sheets{position:relative}
  .sheets.n2{margin:0 6px 6px 0} .sheets.n3{margin:0 12px 12px 0}
  .sheet{position:absolute;inset:0;border-radius:10px;background:#fff;box-shadow:0 0 0 1px var(--line),0 1px 2px rgba(0,27,55,.06)}
  .sheet.s2{transform:translate(6px,6px)} .sheet.s3{transform:translate(12px,12px)}
  .group.stack:hover .sheet.s2{transform:translate(7px,7px)} .group.stack:hover .sheet.s3{transform:translate(14px,14px)}
  .sheet{transition:transform .2s var(--ease)}
  .stack .thumb{position:relative;z-index:1;background:#fff;box-shadow:0 0 0 1px var(--line)}
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
  .cut{position:absolute;left:-14px;top:calc(50% - 24px);width:24px;height:24px;margin-left:-7px;border-radius:50%;background:#fff;color:var(--sub);box-shadow:0 1px 4px rgba(0,27,55,.18);display:grid;place-items:center;opacity:0;transform:scale(.8);transition:opacity .15s var(--ease),transform .15s var(--ease),color .15s;z-index:2}
  .group:hover .cut{opacity:1;transform:none}
  .cut:hover{color:var(--primary)}
  .page.enter{animation:enter .35s var(--ease) both}
  @keyframes enter{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:none}}
  .thumb{aspect-ratio:1/1.414;border-radius:10px;background:var(--fill);display:grid;place-items:center;overflow:hidden}
  .thumb img{max-width:100%;max-height:100%;display:block;box-shadow:0 0 0 1px var(--line);transition:transform .25s var(--ease)}
  .thumb.rot90 img,.thumb.rot270 img{max-width:70.7%}
  .skeleton{width:100%;height:100%;background:linear-gradient(90deg,#EEF0F3 25%,#F7F8FA 50%,#EEF0F3 75%);background-size:200% 100%;animation:shimmer 1.2s linear infinite}
  @keyframes shimmer{from{background-position:200% 0}to{background-position:-200% 0}}
  .badge{min-width:24px;height:22px;padding:0 7px;border-radius:999px;background:var(--ink);color:#fff;font-size:12px;font-weight:700;display:grid;place-items:center;flex:none}
  .acts{position:absolute;top:6px;right:6px;display:flex;gap:4px;opacity:0;transition:opacity .15s var(--ease)}
  .page:hover .acts,.page:focus-within .acts{opacity:1}
  .act{width:32px;height:32px;border-radius:10px;background:rgba(255,255,255,.95);box-shadow:0 1px 4px rgba(0,27,55,.12);display:grid;place-items:center;color:var(--sub)}
  .act:hover{color:var(--ink)}
  .act.del{color:var(--danger)}
  .act.del:hover{background:#FFF5F5;color:var(--danger)}
  .cap{display:flex;align-items:center;gap:8px;margin-top:8px;font-size:12px;color:var(--muted);padding:0 2px}
  .cap .dot{width:6px;height:6px;border-radius:50%;flex:none}
  .cap .nm{white-space:nowrap;overflow:hidden;text-overflow:ellipsis;flex:1}
  .ghost{opacity:.35}
  .chosen{box-shadow:0 0 0 1.5px var(--ring-h,transparent),0 12px 32px rgba(0,27,55,.18)!important}

  /* bottom bar */
  .bar{position:fixed;left:0;right:0;bottom:0;z-index:10;background:rgba(255,255,255,.96);border-top:1px solid var(--line);transform:translateY(100%);transition:transform .3s var(--ease)}
  .bar.show{transform:none}
  .bar .in{max-width:1080px;margin:0 auto;padding:14px 24px;display:flex;align-items:center;gap:12px}
  .sum{font-size:14px;color:var(--sub);flex:none}
  .sum b{color:var(--ink)}
  .name{flex:1;display:flex;align-items:center;height:44px;background:var(--fill);border-radius:12px;padding:0 14px;border:1px solid transparent}
  .name:focus-within{border-color:var(--primary);background:#fff}
  .name input{flex:1;border:0;background:none;font:inherit;font-size:15px;outline:none;min-width:0;color:var(--ink)}
  .name input::placeholder{color:#B0B8C1}
  .name span{color:var(--muted);font-size:15px}
  .warn{font-size:13px;color:#B25E09}
  .spin{width:18px;height:18px;border-radius:50%;border:2.5px solid rgba(255,255,255,.4);border-top-color:#fff;animation:spin .7s linear infinite}
  @keyframes spin{to{transform:rotate(360deg)}}

  /* toast */
  .toast{position:fixed;z-index:30;left:50%;bottom:96px;transform:translate(-50%,12px);opacity:0;pointer-events:none;background:#333D4B;color:#fff;border-radius:999px;padding:12px 20px;font-size:14px;display:flex;align-items:center;gap:14px;transition:opacity .2s var(--ease),transform .2s var(--ease);white-space:nowrap}
  .toast.show{opacity:1;transform:translate(-50%,0);pointer-events:auto}
  .toast button{color:#64A8FF;font-weight:600;display:inline-flex;align-items:center;gap:8px}
  .toast kbd{font:inherit;font-size:11px;font-weight:600;color:#C5CCD3;background:rgba(255,255,255,.12);border:1px solid rgba(255,255,255,.18);border-bottom-width:2px;border-radius:6px;padding:1px 6px;letter-spacing:.02em}
  @media (hover:none){ .toast kbd{display:none} }

  /* modal */
  .scrim{position:fixed;inset:0;z-index:40;background:rgba(0,0,0,.4);display:grid;place-items:center;opacity:0;pointer-events:none;transition:opacity .2s var(--ease)}
  .scrim.show{opacity:1;pointer-events:auto}
  .modal{background:#fff;border-radius:24px;width:min(400px,calc(100% - 40px));padding:28px 24px 20px;transform:scale(.96);transition:transform .2s var(--ease)}
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
  .drop-ov{position:fixed;inset:12px;z-index:50;border-radius:24px;border:2px dashed var(--primary);background:rgba(232,243,255,.85);display:grid;place-items:center;font-size:18px;font-weight:700;color:var(--primary);opacity:0;pointer-events:none;transition:opacity .15s var(--ease)}
  .drop-ov.show{opacity:1}
  /* viewer */
  .viewer{position:fixed;inset:0;background:rgba(15,19,25,.92);display:flex;flex-direction:column;opacity:0;pointer-events:none;transition:opacity .2s var(--ease);z-index:20}
  .viewer.show{opacity:1;pointer-events:auto}
  .v-top{display:flex;align-items:center;gap:12px;padding:16px 20px;color:#fff;padding-top:max(16px,env(safe-area-inset-top))}
  .v-title{flex:1;min-width:0;font-size:15px;display:flex;align-items:center;gap:10px}
  .v-title .badge{background:#fff;color:var(--ink)}
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
    header{flex-direction:row;align-items:center}
    h1{font-size:22px}
    .lead{font-size:13px}
    .btn-secondary{height:40px;padding:0 14px;font-size:14px}
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
  @media (prefers-reduced-motion:reduce){ *{animation:none!important;transition:none!important} }
</style>
</head>
<body>
<div class="wrap">
  <header>
    <div>
      <h1>PDF 합치기</h1>
      <p class="lead">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/></svg>
        파일은 이 컴퓨터 밖으로 나가지 않아요
      </p>
    </div>
    <button class="btn btn-secondary" id="addBtn" hidden>
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round"><path d="M12 5v14M5 12h14"/></svg>
      파일 추가
    </button>
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
    <label class="name"><input id="outname" value="" placeholder="합본 이름 적기" aria-label="합본 파일 이름" spellcheck="false" autocomplete="off"><span>.pdf</span></label>
    <span class="warn" id="warn" hidden></span>
    <button class="btn btn-primary" id="saveBtn">PDF로 저장</button>
  </div>
</div>

<div class="toast" id="toast" role="status"><span id="toastMsg"></span><button id="toastAct" hidden>되돌리기<kbd id="undoKey">Ctrl+Z</kbd></button></div>

<div class="scrim" id="scrim">
  <form class="modal" id="pwForm" autocomplete="off">
    <h2>암호를 입력해 주세요</h2>
    <p><b id="pwName"></b> 파일에 암호가 걸려 있어요. 암호를 입력하면 풀린 상태로 합쳐요.</p>
    <div class="field" id="pwField"><input type="password" id="pwInput" placeholder="PDF 암호"></div>
    <div class="err-msg" id="pwErr"></div>
    <div class="row">
      <button type="button" class="btn btn-ghost" id="pwLater">나중에</button>
      <button type="submit" class="btn btn-primary">확인</button>
    </div>
  </form>
</div>

<div class="viewer" id="viewer" role="dialog" aria-modal="true" aria-label="페이지 크게 보기">
  <div class="v-top">
    <div class="v-title"><span class="badge" id="vNum"></span><span class="nm" id="vName"></span></div>
    <button class="v-btn" id="vRot" title="오른쪽으로 돌리기" aria-label="오른쪽으로 돌리기"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12a9 9 0 1 1-3-6.7L21 8"/><path d="M21 3v5h-5"/></svg></button>
    <button class="v-btn" id="vClose" title="닫기 (Esc)" aria-label="닫기"><svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round"><path d="M6 6l12 12M18 6L6 18"/></svg></button>
  </div>
  <div class="v-body">
    <button class="v-btn" id="vPrev" title="이전 페이지 (←)" aria-label="이전 페이지"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M15 6l-6 6 6 6"/></svg></button>
    <div class="v-stage" id="vStage"></div>
    <button class="v-btn" id="vNext" title="다음 페이지 (→)" aria-label="다음 페이지"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M9 6l6 6-6 6"/></svg></button>
  </div>
</div>

<div class="drop-ov" id="dropOv">여기에 놓으면 추가돼요</div>
<input type="file" id="picker" accept="application/pdf,image/*" multiple hidden>

<script>__PDFLIB__</script>
<script>__PDFJS__</script>
<script>__SORTABLE__</script>
<script id="worker-src" type="text/plain">__WORKER__</script>
<script id="cmaps" type="application/json">__CMAPS__</script>
<script>
(function(){
  if (location.hostname === '127.0.0.1') setInterval(() => fetch('/ping').catch(()=>{}), 2000);
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

  const $ = id => document.getElementById(id);
  const COLORS = ['#3182F6','#00B386','#FF8A00','#8B5CF6','#06B6D4','#F25291'];
  const files = new Map();   // fid -> {id,name,kind,bytes,mime,color,state:'ready'|'locked'|'error',raster,doc,numPages}
  let pages = [];            // {pid,fid,index,rot,thumb}
  let fseq = 0, pseq = 0, gseq = 0, colorIdx = 0, busy = false;
  const expanded = new Set();   // 펼쳐 놓은 묶음
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
    if (!fn){ toast('더 되돌릴 작업이 없어요'); return; }
    fn(); toast('되돌렸어요');
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
      if (!isPdf && !isImg){ toast('PDF나 사진만 넣을 수 있어요'); continue; }
      let bytes = new Uint8Array(await file.arrayBuffer()), mime = null;
      if (isImg){
        if (/^image\/png$/.test(file.type) || /\.png$/i.test(file.name)) mime = 'png';
        else if (/^image\/jpe?g$/.test(file.type) || /\.jpe?g$/i.test(file.name)) mime = 'jpg';
        else {
          try { bytes = await toJpeg(file); mime = 'jpg'; }
          catch(e){ toast(file.name + '은(는) 이 브라우저에서 열 수 없는 사진이에요'); continue; }
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
    try { await openPdf(f, $('pwInput').value); closePassword(); render(); toast('암호를 풀었어요'); }
    catch(err){
      if (err && err.name === 'PasswordException'){ $('pwErr').textContent = '암호가 맞지 않아요. 다시 확인해 주세요'; $('pwField').classList.add('err'); $('pwInput').select(); }
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
      const cnt = f.state==='ready' ? `${pages.filter(p=>p.fid===f.id).length}쪽` : f.state==='locked' ? '' : '열 수 없는 파일';
      ch.innerHTML = `<span class="dot" style="background:${f.color}"></span><span class="nm"></span><span class="ct">${cnt}</span>`
        + (f.state==='locked' ? '<button class="unlock">암호 입력</button>' : '')
        + `<button class="x" aria-label="파일 빼기" title="파일 빼기">${ICON_X}</button>`;
      ch.querySelector('.nm').textContent = f.name;
      ch.querySelector('.x').onclick = () => removeFile(f.id);
      const u = ch.querySelector('.unlock'); if (u) u.onclick = () => askPassword(f.id);
      fc.appendChild(ch);
    }

    // groups (연속된 같은 gid = 한 묶음)
    const grid = $('grid'); grid.innerHTML = '';
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
        const title = fids.length === 1 ? f0.name : `${f0.name} 외 ${fids.length-1}개`;
        box.innerHTML = `<div class="sheets n${layers}">
            ${layers >= 3 ? '<div class="sheet s3"></div>' : ''}${layers >= 2 ? '<div class="sheet s2"></div>' : ''}
            <div class="thumb rot${r}" data-tp="${p.pid}">${p.thumb ? `<img alt="" src="${p.thumb}" style="transform:rotate(${p.rot}deg)">` : '<div class="skeleton"></div>'}</div>
          </div>
          <div class="acts">
            ${cnt > 1 ? `<button class="act" data-a="expand" title="쪽별로 펼치기" aria-label="쪽별로 펼치기">${ICON_EXPAND}</button>`
                      : `<button class="act" data-a="rot" title="오른쪽으로 돌리기" aria-label="오른쪽으로 돌리기">${ICON_ROT}</button>`}
            <button class="act del" data-a="del" title="${cnt > 1 ? '이 묶음 빼기' : '이 페이지 빼기'}" aria-label="${cnt > 1 ? '이 묶음 빼기' : '이 페이지 빼기'}">${ICON_DEL}</button>
          </div>
          <div class="c-title hd-nm"></div>
          <div class="c-meta"><span class="badge">${cnt > 1 ? start + '–' + n : start}</span><span class="dot" style="background:${f0.color}"></span><span class="hd-fn"></span><span class="ct">${cnt}쪽</span></div>`;
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
      const title = fids.length === 1 ? f0.name : `${f0.name} 외 ${fids.length-1}개`;
      box.innerHTML = `<div class="g-head"><span class="dot" style="background:${f0.color}"></span><span class="nm hd-nm"></span><span class="fn hd-fn"></span><span class="ct">${g.items.length}쪽</span><span class="sp"></span>
          ${g.items.length > 8 ? `<label class="jump" title="이 묶음 안의 쪽 번호로 이동"><span class="lbl">쪽 이동</span><input type="number" min="1" max="${g.items.length}" inputmode="numeric" aria-label="이동할 쪽 번호"><span>/ ${g.items.length}</span></label>` : ''}
          <button class="g-btn" data-a="fold" title="다시 겹쳐서 보기">접기</button>
          ${g.items.length > 1 ? '<button class="g-btn" data-a="split" title="한 쪽씩 따로 움직이게 풀기">묶음 풀기</button>' : ''}
          ${gi > 0 ? '<button class="g-btn" data-a="join" title="바로 앞 묶음과 합치기">앞과 묶기</button>' : ''}
          <button class="g-btn x" data-a="rmg" title="이 묶음 빼기" aria-label="이 묶음 빼기">${ICON_DEL}</button></div>
        <div class="g-wrap"><div class="fade l"></div><div class="fade r"></div>
          <button class="scroll-btn l" aria-label="왼쪽으로 넘기기"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M15 6l-6 6 6 6"/></svg></button>
          <button class="scroll-btn r" aria-label="오른쪽으로 넘기기"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M9 6l6 6-6 6"/></svg></button>
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
        el.innerHTML = `${k > 0 ? `<button class="cut" title="여기서 나누기" aria-label="여기서 나누기">${ICON_CUT}</button>` : ''}
          <div class="thumb rot${r}" data-tp="${p.pid}">${p.thumb ? `<img alt="" src="${p.thumb}" style="transform:rotate(${p.rot}deg)">` : '<div class="skeleton"></div>'}</div>
          <div class="acts">
            <button class="act" data-a="rot" title="오른쪽으로 돌리기" aria-label="오른쪽으로 돌리기">${ICON_ROT}</button>
            <button class="act del" data-a="del" title="이 페이지 빼기" aria-label="이 페이지 빼기">${ICON_DEL}</button>
          </div>
          <div class="cap"><span class="badge">${n}</span><span class="nm">${f.numPages>1 ? (p.index+1)+'쪽' : ''}</span></div>`;
        if (fids.length > 1) el.querySelector('.cap .nm').textContent = f.name.replace(/\.[^.]+$/, '') + (f.numPages>1 ? ' · ' + (p.index+1) + '쪽' : '');
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
    render(); toast('묶음을 나눴어요', () => restore(snap));
  }
  function ungroup(gid){
    const snap = snapshot();
    pages.forEach(p => { if (p.gid === gid) p.gid = ++gseq; });
    render(); toast('한 쪽씩 따로 움직일 수 있어요', () => restore(snap));
  }
  function joinPrev(gid){
    const snap = snapshot();
    const i = pages.findIndex(x => x.gid === gid); if (i <= 0) return;
    const prev = pages[i-1].gid;
    pages.forEach(p => { if (p.gid === gid) p.gid = prev; });
    if (expanded.has(gid)) expanded.add(prev);
    render(); toast('앞 묶음과 합쳤어요', () => restore(snap));
  }
  function removeGroup(gid){
    const snap = snapshot();
    const cnt = pages.filter(p => p.gid === gid).length;
    pages = pages.filter(p => p.gid !== gid);
    render(); removedCleanup(); toast(`${cnt}쪽을 뺐어요`, () => restore(snap));
  }

  function updateBar(){
    const ready = [...files.values()].filter(f => !f.removed && f.state==='ready' && pages.some(p => p.fid === f.id)).length;
    $('sum').innerHTML = `<b>${pages.length}쪽</b> · 파일 ${ready}개`;
    const locked = [...files.values()].some(f => !f.removed && f.state==='locked');
    $('warn').hidden = !locked; $('warn').textContent = locked ? '암호를 입력하지 않은 파일은 빠져요' : '';
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
    toast(`${i+1}쪽을 뺐어요`, () => restore(snap));
  }
  function removeFile(fid){
    const f = files.get(fid);
    const snap = snapshot();
    pages = pages.filter(p=>p.fid!==fid); f.removed = true;
    render(); removedCleanup();
    toast(`${f.name}을(를) 뺐어요`, () => { f.removed = false; restore(snap); });
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
    $('vName').textContent = (gFirst && gFirst.title ? gFirst.title + ' · ' : '') + f.name + (f.numPages > 1 ? ` · ${p.index+1}쪽` : '');
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
    btn.innerHTML = '<span class="spin"></span><span id="prog">만드는 중</span>';
    try {
      const bytes = await build((i,t) => { const el = $('prog'); if (el) el.textContent = `${i}/${t}쪽`; });
      const d = new Date(), pad = x => String(x).padStart(2,'0');
      const today = `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}`;
      let name = ($('outname').value.trim().replace(/\.pdf$/i,'').replace(/[\\/:*?"<>|]/g,'_') || `합본_${today}`) + '.pdf';
      const a = document.createElement('a');
      a.href = URL.createObjectURL(new Blob([bytes], {type:'application/pdf'})); a.download = name;
      document.body.appendChild(a); a.click(); a.remove();
      setTimeout(() => URL.revokeObjectURL(a.href), 60000);
      window.__lastBytes = bytes;
      toast(`${name}을(를) 저장했어요`);
    } catch(e){ console.error(e); toast('저장하지 못했어요. 파일을 다시 확인해 주세요'); }
    busy = false; btn.textContent = 'PDF로 저장'; updateBar();
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
  window.__app = { addFiles, get pages(){ return pages; }, files, move(from,to){ const [p]=pages.splice(from,1); pages.splice(to,0,p); render(); } };
  if (matchMedia('(hover:none)').matches){
    $('hint').textContent = '꾹 눌러서 끌면 순서가 바뀌어요. 여러 쪽짜리는 펼쳐서 쪽별로 나눌 수 있어요.';
    $('emptyTitle').textContent = '눌러서 PDF나 사진을 골라 주세요';
    document.querySelector('.empty p').innerHTML = 'PDF, 사진(JPG, PNG, HEIC)<br>넣은 파일의 모든 페이지를 원하는 순서로 섞을 수 있어요';
  }
  window.__app.openViewer = openViewer;
  render();
})();
</script>
</body>
</html>
