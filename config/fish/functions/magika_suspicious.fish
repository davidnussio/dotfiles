function magika_suspicious
    set target (test -n "$argv[1]"; and echo $argv[1]; or echo ".")
    
    echo "🔍 Scanning $target for suspicious files..."
    echo ""
    
    magika --json -r $target 2>/dev/null | \
    python3 -c "
import sys, json

data = json.load(sys.stdin)
suspicious = []

dangerous_types = {'elf', 'elf32', 'elf64', 'macho', 'pe', 'shell', 'bash', 'python', 'javascript', 'php', 'powershell', 'lisp'}
safe_extensions = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'pdf', 'docx', 'xlsx', 'mp3', 'mp4', 'txt', 'csv'}

for entry in data:
    path = entry.get('path', '')
    value = entry.get('result', {}).get('value', {})
    label = value.get('output', {}).get('label', '')
    score = value.get('score', 0)
    ext = path.rsplit('.', 1)[-1].lower() if '.' in path else ''
    
    if label in dangerous_types and ext in safe_extensions and score > 0.85:
        severity = 'HIGH' if ext in {'jpg','jpeg','png','gif','pdf','docx','xlsx'} else 'MEDIUM'
        suspicious.append((severity, path, ext, label, score))

if not suspicious:
    print('✅ No suspicious files found.')
else:
    print(f'🚨 Found {len(suspicious)} suspicious file(s):\n')
    for sev, path, ext, label, score in sorted(suspicious, reverse=True):
        icon = '🔴' if sev == 'HIGH' else '🟡'
        print(f'{icon} [{sev}] {path}')
        print(f'   Declared: .{ext}  →  Detected: {label}  (score: {score:.2f})')
        print()
"
end
