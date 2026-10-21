# Bash Notes --- أساسيات Bash Scripting

> ملاحظات عملية ضمن رحلتي لتعلّم Bash تمهيدًا لمسار DevOps Engineer.
>
> **البيئة:** Linux / Kali / Ubuntu داخل VirtualBox أو VMware أو WSL\
> **الهدف:** مراجعة الـ Syntax والأمثلة الأساسية بسرعة.

------------------------------------------------------------------------

## 1. شكل سكريبت Bash

``` bash
#!/usr/bin/env bash

echo "Hello, world!"
```

-   `#!/usr/bin/env bash` --- يحدد أن السكريبت يعمل باستخدام Bash.
-   `#` --- بداية تعليق، ولا يُنفَّذ.
-   `echo` --- يطبع نصًا في الطرفية.

لتشغيل السكريبت:

``` bash
chmod +x script.sh
./script.sh
```

أو تشغيله باستخدام Bash مباشرةً:

``` bash
bash script.sh
```

> مهم: `[[ ... ]]` و`(( ... ))` من صياغات Bash. شغّل السكريبت باستخدام
> Bash، ولا تستخدم `sh script.sh` إذا كان يعتمد على هذه الصياغات.

--------------------------------------------------------------------------

## 2. المتغيرات Variables

### تعريف متغير واستخدامه

``` bash
name="Ammar"
age=22

echo "$name"
echo "$age"
echo "Hello, $name!"
```

**قواعد مهمة:** - لا تضع مسافات حول `=` عند إسناد قيمة. - استخدم علامات
الاقتباس حول النصوص، خصوصًا إذا احتوت على مسافات. - أسماء المتغيرات حساسة
لحالة الأحرف: `name` مختلف عن `NAME`.

``` bash
# صحيح
city="Beni Suef"

# خطأ: وجود مسافات حول =
# city = "Beni Suef"
```

### المتغيرات للقراءة فقط

``` bash
readonly APP_NAME="server-monitor"
```

### متغيرات البيئة

``` bash
export APP_ENV="development"
```

------------------------------------------------------------------------

## 3. استخدامات علامة الدولار `$`

### `$variable` --- قيمة متغير

``` bash
name="Ammar"
echo "$name"
```

### `${variable}` --- تحديد حدود اسم المتغير

مفيد عندما يأتي بعد اسم المتغير نص مباشر:

``` bash
name="server"
echo "${name}_backup"
# server_backup
```

### `${variable:-default}` --- قيمة افتراضية عند عدم التعيين أو الفراغ

``` bash
name="${USER_NAME:-Guest}"
echo "$name"
```

### `$(command)` --- Command Substitution

تشغيل أمر ووضع ناتجه داخل متغير أو نص:

``` bash
today=$(date +%F)
echo "$today"

file_count=$(find . -maxdepth 1 -type f | wc -l)
echo "$file_count"
```

### `$?` --- كود خروج آخر أمر

``` bash
ping -c 1 127.0.0.1

if [[ $? -eq 0 ]]; then
    echo "Command succeeded"
else
    echo "Command failed"
fi
```

الأفضل غالبًا اختبار الأمر مباشرةً بدل الاعتماد على `$?`:

``` bash
if ping -c 1 127.0.0.1 >/dev/null 2>&1; then
    echo "Command succeeded"
else
    echo "Command failed"
fi
```

### `$#` --- عدد الوسائط (Arguments)

``` bash
echo "Number of arguments: $#"
```

### `$1`, `$2`, ... --- الوسائط الممررة للسكريبت

``` bash
echo "First argument: $1"
echo "Second argument: $2"
```

تشغيل المثال:

``` bash
./script.sh alpha beta
```

### `$@` --- كل الوسائط

``` bash
for arg in "$@"; do
    echo "$arg"
done
```

استخدام `"$@"` يحافظ على كل وسيط كعنصر مستقل، حتى لو احتوى على مسافات.

### `$$` --- رقم عملية السكريبت الحالية (PID)

``` bash
echo "PID: $$"
```

------------------------------------------------------------------------

## 4. إدخال المستخدم باستخدام `read`

``` bash
read -p "Enter your name: " user_name
echo "Welcome, $user_name!"
```

-   `read` يقرأ إدخال المستخدم.
-   `-p` مع `read` تعرض رسالة Prompt قبل الإدخال.

### التحقق من أن الإدخال ليس فارغًا

``` bash
read -r -p "Enter your name: " user_name

if [[ -z "$user_name" ]]; then
    echo "Error: name cannot be empty"
    exit 1
fi

echo "Welcome, $user_name!"
```

-   `-r` يمنع `read` من التعامل مع `\` كحرف هروب.
-   `-z "$user_name"` يتحقق هل طول النص صفر.
-   `exit 1` ينهي السكريبت بكود يدل على الفشل؛ `exit 0` يدل عادةً على
    النجاح.

------------------------------------------------------------------------

## 5. الشروط `if / elif / else`

### الصياغة العامة

``` bash
if [[ condition ]]; then
    # commands
elif [[ another_condition ]]; then
    # commands
else
    # commands
fi
```

### مثال

``` bash
read -r -p "Enter your age: " age

if [[ "$age" -ge 18 ]]; then
    echo "Adult"
else
    echo "Under 18"
fi
```

> المثال يفترض أن الإدخال رقم صحيح. للتحقق من أن الإدخال رقمي قبل
> المقارنة، يلزم إضافة فحص منفصل.

### قواعد المسافات

``` bash
# صحيح
if [[ -z "$name" ]]; then
    echo "Empty"
fi

# خطأ
# if[[-z "$name"]];then
```

يجب الفصل بمسافات بين `[[` ومحتوى الشرط، وكذلك قبل `]]`.

------------------------------------------------------------------------

## 6. جمل الاختبار: `[ ]` و`[[ ]]`

### `[ ... ]`

صياغة الاختبار التقليدية، وهي مناسبة لعدد كبير من اختبارات النصوص
والأرقام والملفات:

``` bash
if [ -f "$file" ]; then
    echo "File exists"
fi
```

تحتاج مسافات داخلية صحيحة، و`]` الأخيرة يجب أن تكون منفصلة بمسافة.

### `[[ ... ]]`

صياغة Bash المتقدمة للاختبارات:

``` bash
if [[ -f "$file" ]]; then
    echo "File exists"
fi
```

غالبًا يُفضَّل استخدامها في سكريبتات Bash، مع تذكّر أنها ليست صياغة POSIX
`sh`.

### النفي `!`

``` bash
if [[ ! -d "$dir" ]]; then
    echo "Directory does not exist"
fi
```

المسافة مهمة: `[[ ! -d ... ]]` وليس `[[! -d ... ]]`.

------------------------------------------------------------------------

## 7. مقارنة النصوص (String Comparisons)

تُستخدم عادةً مع `[[ ... ]]`:

  الاختبار               المعنى
  ---------------------- -----------------
  `[[ -z "$s" ]]`        النص فارغ
  `[[ -n "$s" ]]`        النص غير فارغ
  `[[ "$a" == "$b" ]]`   النصان متساويان
  `[[ "$a" != "$b" ]]`   النصان مختلفان

### أمثلة

``` bash
name="Ammar"

if [[ -z "$name" ]]; then
    echo "Empty"
elif [[ "$name" == "Ammar" ]]; then
    echo "Hello, Ammar"
else
    echo "Another name"
fi
```

**ملاحظة:** ضع المتغيرات بين علامات اقتباس كعادة واضحة، حتى عندما لا
تكون ضرورية داخل `[[ ... ]]`.

------------------------------------------------------------------------

## 8. مقارنة الأرقام (Numeric Comparisons)

مع `[ ... ]` أو `[[ ... ]]`، استخدم معاملات المقارنة التالية:

  المعامل   المعنى
  --------- ------------------
  `-eq`     يساوي
  `-ne`     لا يساوي
  `-gt`     أكبر من
  `-ge`     أكبر من أو يساوي
  `-lt`     أصغر من
  `-le`     أصغر من أو يساوي

### مثال

``` bash
a=10
b=20

if [[ "$a" -lt "$b" ]]; then
    echo "$a is less than $b"
fi
```

### الحسابات العددية باستخدام `(( ))`

داخل `(( ))`، استخدم معاملات الرياضيات المعتادة:

``` bash
count=0
((count++))
((count += 2))

echo "$count"
```

أمثلة مقارنة داخل `(( ))`:

``` bash
if (( a < b )); then
    echo "a is less than b"
fi
```

**الفرق:** - `[[ "$a" -lt "$b" ]]` --- مقارنة عددية داخل test. -
`(( a < b ))` --- تعبير حسابي في Bash، مناسب للحساب والمقارنة العددية.

------------------------------------------------------------------------

## 9. اختبار الملفات والمجلدات (File Tests)

استخدم هذه الاختبارات داخل `[ ... ]` أو `[[ ... ]]`.

  الاختبار       المعنى
  -------------- -----------------------------------
  `-e "$path"`   المسار موجود
  `-f "$path"`   المسار ملف عادي
  `-d "$path"`   المسار مجلد
  `-r "$path"`   يمكن قراءة المسار
  `-w "$path"`   يمكن الكتابة إلى المسار
  `-x "$path"`   يمكن تنفيذ الملف أو اجتياز المجلد
  `-s "$path"`   الملف موجود وحجمه أكبر من صفر
  `-L "$path"`   المسار رابط رمزي (Symbolic Link)

### التحقق من وجود ملف

``` bash
FILE="servers.txt"

if [[ ! -f "$FILE" ]]; then
    echo "Error: file not found: $FILE"
    exit 1
fi

echo "File exists"
```

### التحقق من وجود مجلد

``` bash
DIR="/tmp/backup"

if [[ -d "$DIR" ]]; then
    echo "Directory exists"
else
    echo "Directory does not exist"
fi
```

### إنشاء مجلد بأمان إذا لم يكن موجودًا

``` bash
mkdir -p "/tmp/backup"
```

`mkdir -p` ينشئ المجلدات الأب اللازمة ويتعامل مع وجود المجلد مسبقًا دون
الفشل لمجرد أنه موجود.

------------------------------------------------------------------------

## 10. حلقة `for`

### الصياغة الأساسية

``` bash
for item in value1 value2 value3; do
    echo "$item"
done
```

### التكرار على قائمة

``` bash
for server in 8.8.8.8 1.1.1.1; do
    echo "Checking: $server"
done
```

### التكرار على أرقام

``` bash
for i in {1..5}; do
    echo "$i"
done
```

### قراءة ملف سطرًا بسطر --- الطريقة الموصى بها

بدل `for server in $(cat servers.txt)`، استخدم `while read` لتجنّب مشاكل
تقسيم النصوص والمسافات:

``` bash
while IFS= read -r server || [[ -n "$server" ]]; do
    [[ -z "$server" ]] && continue
    echo "Checking: $server"
done < "servers.txt"
```

------------------------------------------------------------------------

## 11. حلقة `while`

### الصياغة العامة

``` bash
while [[ condition ]]; do
    # commands
done
```

### مثال عدّاد

``` bash
count=1

while [[ "$count" -le 5 ]]; do
    echo "$count"
    ((count++))
done
```

تستمر الحلقة ما دام الشرط صحيحًا. تأكد أن جسم الحلقة يغيّر الحالة أو ينفذ
`break` عند الحاجة، وإلا قد تستمر بلا نهاية.

------------------------------------------------------------------------

## 12. جملة `case`

مفيدة عندما تريد الاختيار بين عدة قيم واضحة:

``` bash
read -r -p "Choose an option (start/stop/status): " action

case "$action" in
    start)
        echo "Starting..."
        ;;
    stop)
        echo "Stopping..."
        ;;
    status)
        echo "Checking status..."
        ;;
    *)
        echo "Invalid option"
        exit 1
        ;;
esac
```

-   `case "$action" in` --- بداية الاختيار.
-   `value)` --- بداية فرع يطابق القيمة.
-   `;;` --- نهاية الفرع.
-   `*)` --- الفرع الافتراضي.
-   `esac` --- نهاية `case`.

يمكن مطابقة أكثر من قيمة في فرع واحد:

``` bash
case "$action" in
    start|run)
        echo "Starting..."
        ;;
    *)
        echo "Unknown action"
        ;;
esac
```

------------------------------------------------------------------------
## 13. Bash Data Streams

- stdin (0): Standard Input
- stdout (1): Standard Output
- stderr (2): Standard Error

### Output Redirection
- `>`: Redirect stdout and overwrite the file.
- `>>`: Append stdout to the file.
- `2>`: Redirect stderr and overwrite the file.
- `2>>`: Append stderr to the file.
- `&>`: Redirect stdout and stderr to one file in Bash.
- `>/dev/null 2>&1`: Discard both stdout and stderr.
--------------------------------------------------------------------------

## 14. كود الخروج `exit status`

كل أمر يعيد كود خروج: - `0` يعني نجاحًا عادةً. - أي قيمة غير صفرية تعني
فشلًا أو حالة خاصة بالأمر.

``` bash
if ping -c 1 127.0.0.1 >/dev/null 2>&1; then
    echo "UP"
else
    echo "DOWN"
fi
```

-   `>/dev/null` يخفي المخرجات العادية.
-   `2>&1` يوجّه مخرجات الأخطاء إلى نفس الوجهة.
-   `if command; then` طريقة أوضح لاختبار نجاح الأمر.

------------------------------------------------------------------------

## 14. مثال تطبيقي: فحص قائمة سيرفرات

أنشئ ملف `servers.txt` مثلًا:

``` text
8.8.8.8
1.1.1.1
192.0.2.1
```

`192.0.2.1` من نطاق مخصص للأمثلة والتوثيق، ويُستخدم هنا كوجهة اختبار غير
متوقع أن تكون سيرفرًا عامًا قابلًا للوصول. نتيجة الـ Ping تعتمد على الشبكة،
لذلك لا تعتبرها وحدها دليلًا قاطعًا على حالة سيرفر حقيقي.

ملف `monitor.sh`:

``` bash
#!/usr/bin/env bash

SERVERS_FILE="servers.txt"

if [[ ! -f "$SERVERS_FILE" ]]; then
    echo "Error: server list not found: $SERVERS_FILE"
    exit 1
fi

up_count=0
down_count=0

echo "--- Starting server monitoring ---"

while IFS= read -r server || [[ -n "$server" ]]; do
    # تجاهل الأسطر الفارغة
    [[ -z "$server" ]] && continue

    if ping -c 2 -W 2 "$server" >/dev/null 2>&1; then
        echo "[UP] $server"
        ((up_count++))
    else
        echo "[DOWN] $server"
        ((down_count++))
    fi

    sleep 1
done < "$SERVERS_FILE"

echo "-------------------------------"
echo "Total checked: $((up_count + down_count))"
echo "UP: $up_count"
echo "DOWN: $down_count"
echo "-------------------------------"
```

شغّله:

``` bash
chmod +x monitor.sh
./monitor.sh
```

> تنبيه: فشل `ping` يعني أن اختبار ICMP فشل، وليس بالضرورة أن السيرفر
> متوقف؛ قد تكون الشبكة أو الجدار الناري يمنعان ICMP.

------------------------------------------------------------------------

## 15. أخطاء Syntax شائعة

### نسيان المسافات في `[[ ]]`

``` bash
# صحيح
if [[ -z "$name" ]]; then
    echo "Empty"
fi

# خطأ
# if[[-z "$name"]];then
```

### نسيان المسافات حول `!`

``` bash
# صحيح
[[ ! -f "$file" ]]

# خطأ
# [[! -f "$file" ]]
```

### مسافات حول إسناد المتغير

``` bash
# صحيح
name="Ammar"

# خطأ
# name = "Ammar"
```

### استخدام `=` للمقارنة النصية و`-eq` للأرقام

``` bash
[[ "$name" == "Ammar" ]]
[[ "$count" -eq 3 ]]
```

### تذكّر إغلاق الكتل

``` bash
if [[ condition ]]; then
    echo "OK"
fi

for item in a b c; do
    echo "$item"
done

while [[ condition ]]; do
    echo "Loop"
done

case "$value" in
    a) echo "A" ;;
    *) echo "Other" ;;
esac
```

------------------------------------------------------------------------

## 16. قائمة مراجعة قبل تشغيل السكريبت

-   [ ] هل يبدأ الملف بـ `#!/usr/bin/env bash`؟
-   [ ] هل توجد مسافات صحيحة داخل `[[ ... ]]` و`[ ... ]`؟
-   [ ] هل استخدمت `"$variable"` عند التعامل مع قيم نصية؟
-   [ ] هل فرّقت بين مقارنة النصوص ومقارنة الأرقام؟
-   [ ] هل استخدمت `-f` للملف و`-d` للمجلد؟
-   [ ] هل أغلقت `if` بـ `fi`، و`for`/`while` بـ `done`، و`case` بـ
    `esac`؟
-   [ ] هل اختبرت نجاح الأوامر المهمة؟
-   [ ] هل اختبرت الحالات الفاشلة، مثل ملف غير موجود أو إدخال فارغ؟

------------------------------------------------------------------------

## الخطوة التالية في رحلتي

بعد مراجعة هذه الأساسيات، أطبّقها في سكريبتات صغيرة، ثم أنتقل إلى: 1.
Functions وتنظيم السكريبت. 2. التعامل مع الملفات والـ logs. 3. `grep`,
`cut`, `awk`, `sed` وعمليات الـ pipes. 4. Git وGitHub لإدارة المشاريع.
5. مشاريع مراقبة بسيطة تمهيدًا لـ Prometheus وGrafana.
