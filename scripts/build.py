"""src/app.html.tpl 에 라이브러리와 한국어 CMap을 넣어 하나짜리 index.html을 만든다.

사용법: npm install && npm run build
"""
import base64, json, os, sys

src, dst = sys.argv[1], sys.argv[2]
nm = 'node_modules'
t = open(src, encoding='utf-8').read()
lib = open(f'{nm}/pdf-lib/dist/pdf-lib.min.js', encoding='utf-8').read()
# pdf.js 4판부터는 ES 모듈(.mjs)로만 나온다. 템플릿에서 <script type="module">로 넣는다.
pdfjs = open(f'{nm}/pdfjs-dist/build/pdf.min.mjs', encoding='utf-8').read()
sortable = open(f'{nm}/sortablejs/Sortable.min.js', encoding='utf-8').read()
worker = open(f'{nm}/pdfjs-dist/build/pdf.worker.min.mjs', encoding='utf-8').read().rstrip()

# 내려받은 index.html을 더블클릭(file://)으로 열면 크롬·엣지가 blob 주소의 모듈 워커를 막는다.
# 그러면 pdf.js가 화면 스레드에서 PDF를 읽어(fake worker) 큰 파일에서 화면이 멈춘다.
# 일반(classic) 워커로 돌 수 있도록 모듈 문법 두 가지만 바꾼다. pdf.js를 올렸을 때 모양이 달라지면 빌드를 멈춘다.
tail = 'export{WorkerMessageHandler};'
assert worker.endswith(tail), 'pdf.worker.min.mjs 끝 모양이 달라짐: build.py 확인 필요'
assert worker.count('import.meta') == worker.count('import.meta.url') == 2, 'import.meta 사용처가 달라짐: build.py 확인 필요'
worker = worker[:-len(tail)].replace('import.meta.url', 'self.location.href').replace('</script', '<\\/script')

for s in (lib, pdfjs, sortable):
    assert '</script' not in s.lower()


def b64(path):
    return base64.b64encode(open(path, 'rb').read()).decode()


# 한국어 PDF를 읽는 데 필요한 문자 변환표(CMap)만 골라 넣기
cdir = f'{nm}/pdfjs-dist/cmaps'
cmaps = {f[:-6]: b64(os.path.join(cdir, f))
         for f in os.listdir(cdir)
         if f.endswith('.bcmap') and any(k in f for k in ('KSC', 'Korea', 'UniKS'))}

# 스캔 문서에 흔한 JBIG2, JPEG 2000 이미지 해독기(pdf.js 5판부터 WebAssembly로 분리됨)
wdir = f'{nm}/pdfjs-dist/wasm'
wasm = {f: b64(os.path.join(wdir, f)) for f in ('jbig2.wasm', 'openjpeg.wasm')}

out = (t.replace('__CMAPS__', json.dumps(cmaps))
        .replace('__WASM__', json.dumps(wasm))
        .replace('__PDFLIB__', lib)
        .replace('__PDFJS__', pdfjs)
        .replace('__SORTABLE__', sortable)
        .replace('__WORKER__', worker))
open(dst, 'w', encoding='utf-8').write(out)
print(f'{dst} 생성 ({len(out)/1024/1024:.1f} MB)')
