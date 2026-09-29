# Linux Commands

## pwd
Shows the current directory.
بتظهر الفولدر اللي انت موجود فيه.
## ls  
###  {-a | -l | -al}
Lists files and directories.
## cd
Changes the current directory.
## man + (command name)
info about the command.
بيديني معلومات عن الأمر وكل الإضافات اللي ممكن أستخدمها معاه. 
## cp
Copies files.
## touch
Creates an empty file.
## mv
Moves or renames a file.
## rm
Removes files or non-empty directories.
## rmdir
Removes empty directories.
## mkdir
Creates a directory.
## cat
print file content.
## grep
search for text in file.
## head    
### {-n + number of lines}
display the first 10 lined of a file.
## tail
### {-n + number of lines | -f }
display the last 10 lined of a file.
## less 
display text from file in one screen. الفرق بين less,cat 
less:بتعرض محتويات الملف علي قد الشاشه بس ولو عايز تشوف باقي محتويات الملف اضغط enter
cat:بتعرض محتويات الملف كله مره واحده
## ps  {-aux}
display list of running processes.
## lsof             syntax lsof [الأوبشنز] [الملف أو الفلتر المطلوب]
display list of open files.
{-i: بيعرض كل الاتصالات الشبكية (Network Connections) والبورتات المفتوحة.

-i :[رقم البورت]: بيعرفك إيه العملية (Process) اللي شغالة على بورت معين (مثلا: lsof -i :80).

-u [اسم المستخدم]: بيعرض كل الملفات والعمليات المفتوحة بواسطة مستخدم معين.

-p [رقم Process ID]: بيعرض الملفات المفتوحة بواسطة عملية برمجية محددة برقم الـ PID بتاعها.

-c [اسم العملية]: بيعرض الملفات المفتوحة بواسطة برنامج أو عملية بالاسم (مثلا: lsof -c nginx).

+D [اسم المجلد]: بيبحث بشكل تداخلي (Recursive) عن أي عملية فاتحة ملف جوه المجلد ده.

-t: بيطلع أرقام العمليات (PIDs) بس بدون تفاصيل (مفيدة جداً لو هتركبها مع أوامر تانية زي kill).

-a: بيستخدم لعمل ربط (AND) بين الشروط بدل (OR) الافتراضية.

-n: بيمنع تحويل عناوين الآيبี (IP Addresses) لأسمائهم عشان الأمر يخلص أسرع.

-P: بيمنع تحويل أرقام البورتات لأسمائهم المعروفة (زي http بدل 80) لسرعة التنفيذ.}
## netstat  {-antp}
display network connections.
## ifconfig
display network info.
## sort
sort content of a file.
## uniq
remove duplicate lines (sort first)
## stat
display info about a file.
## ping
test network connectivity.
## whoami
display current user.
## passwd
change user password.
## kill
terminate process.
## find
search on file.
## nano
text editor.
## ln
create link file.
فيه نوعين من اللينك فايل دا هارد لينك وسوفت لينك  الهارد لينك بيشير علي الداتا نفسها يعني لو الفايل الاساسي اتمسح الهارد لينك بيفضل شغال علي عكس السوفت لينك بيشير علي الفايل نفسه ف لو الفايل الاصلي امتسح السوفت لينك مش بيشتغل.










