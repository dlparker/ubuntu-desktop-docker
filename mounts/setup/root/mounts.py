import sys
from pathlib import Path
import shutil
import stat
import os


username=sys.argv[1]
password=sys.argv[2]
domain="LLMNET"

xfer = "//linux3090/xfer /mnt/linux3090/xfer cifs user=dparker,workgroup=DLPLLM,credentials=/etc/smbcreds,uid=1000,gid=1000,noperm,vers=3.0,iocharset=utf8 0 0"
long_term = "linux3090:/mnt/data1/churn/longterm  /mnt/linux3090/longterm  nfs  defaults,timeo=100,noatime,_netdev  0  0"
working = "linux3090:/mnt/data1/churn/working  /mnt/linux3090/working  nfs  defaults,timeo=100,noatime,_netdev  0  0"

xfer_path  = Path('/mnt/linux3090/xfer') 
xfer_path.mkdir(parents=True, exist_ok=True)
shutil.chown(str(xfer_path), user=username, group=username)
long_term_path = Path('/mnt/linux3090/longterm')
long_term_path.mkdir(parents=True, exist_ok=True)
shutil.chown(str(long_term_path), user=username, group=username)
working_path = Path('/mnt/linux3090/working')
working_path.mkdir(parents=True, exist_ok=True)
shutil.chown(str(working_path), user=username, group=username)


creds_content = f"""
username={username}
password={password}
domain={domain}
"""
fstab_path = Path("/etc/fstab")
creds_path = Path("/etc/smbcreds")

if not creds_path.exists():
    with open(creds_path, 'w') as f:
        f.write(creds_content)

with open(fstab_path) as f:
    fstab = f.read()

changed = False
if xfer not in fstab:
    fstab += f"\n{xfer}"
    changed = True
if long_term not in fstab:
    fstab += f"\n{long_term}"
    changed = True
if working not in fstab:
    fstab += f"\n{working}"
    changed = True

if changed:
    with open(fstab_path, 'w') as f:
        f.write(fstab)

os.system("systemctl daemon-reload")
os.system("sudo mount -a")



