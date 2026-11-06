"""src/app.html.tpl 에 라이브러리와 한국어 CMap을 넣어 하나짜리 index.html을 만든다.

사용법: npm install && npm run build
"""
import base64, json, os, sys

src, dst = sys.argv[1], sys.argv[2]
nm = 'node_modules'
t = open(src, encoding='utf-8').read()
lib = open(f'{nm}/pdf-lib/dist/pdf-lib.min.js', encoding='utf-8').read()
pdfjs = open(f'{nm}/pdfjs-dist/build/pdf.min.js', encoding='utf-8').read()
sortable = open(f'{nm}/sortablejs/Sortable.min.js', encoding='utf-8').read()
worker = open(f'{nm}/pdfjs-dist/build/pdf.worker.min.js', encoding='utf-8').read().replace('</script', '<\\/script')
for s in (lib, pdfjs, sortable):
    assert '</script' not in s.lower()

# 한국어 PDF를 읽는 데 필요한 문자 변환표(CMap)만 골라 넣기
cdir = f'{nm}/pdfjs-dist/cmaps'
cmaps = {f[:-6]: base64.b64encode(open(os.path.join(cdir, f), 'rb').read()).decode()
         for f in os.listdir(cdir)
         if f.endswith('.bcmap') and any(k in f for k in ('KSC', 'Korea', 'UniKS'))}

out = (t.replace('__CMAPS__', json.dumps(cmaps))
        .replace('__PDFLIB__', lib)
        .replace('__PDFJS__', pdfjs)
        .replace('__SORTABLE__', sortable)
        .replace('__WORKER__', worker))
open(dst, 'w', encoding='utf-8').write(out)
print(f'{dst} 생성 ({len(out)/1024/1024:.1f} MB)')
