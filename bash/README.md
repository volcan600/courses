# Bash Shell Scripting



### 1.1 Installing Ubuntu Linux
* Install vagrant
* Install virtualbox
* Create a network environmente base on Vagrantfile network
* Move to vagrant folder
```bash
vagrant up
```
```bash
vagrant ssh scripting
```

```bash
# Update the hosts file located on /vagrant/hosts
sudo cp /vagrant/hosts /etc/hosts
```

```bash
echo $SHELL
```

### 1.2 Installing Red Hat Linux
* Applies same configuration than class 1.1

### 1.3 Using Windows Subsystem for Linux
* Applies same configuration than class 1.1

### 1.4 Using the Bash Shell in MacOs
* Since MacOS Catalina, **zsh** is used as the default shell
* To change to bash, open a Terminal, and type **chsh -s /bin/bash**
* Exit the terminal and start it again
* Verify the current shell using **echo $SHELL**

### 2.1 Understanding the Role of Bash
* The is the part of the operating system that interprets command and translate them to machine code that is executed by the kernel
* In Linux, Bash is the default shell
* Before learning how to write scripts in Bash, you should learn a bit about its fundamentals

### 2.2 Using STDIN, STDOUT, STDERR and I/O Redirection
* The Standard Input (STDIN) is where commands are typed
* The Standard Output (STDOUT) is where commands send their result by default
* The Standard Error (STDERR) is where commands send error messages by default

#### Understanding File Descriptors
* In UNIX and Linux, a file descriptor is a unique handle for a file
* As everything in Linux is a file, file descriptors are also used for input and output, (including STDIN, STDERR, STDOUT) and pipes and sockets
* Any file that has been opened by a process is seen as a file descriptor

#### Understanding Redirection
* Redirection allows you to send STDOUT and STDERR to a file, and obtain STDIN from a file

#### Demo

* STDOUT example

```bash
ls
```

* Output redirection example and overrite
```bash
ls > outfile
who > outfile
```

* append redirection example
```bash
ls >> outfile
echo "Hola" >> outfile
```

* Redirect error to /dev/null. It will only shows STDOUT
```bash
grep root /etc/* 2>/dev/null
```

* It is possible to combine
```bash
grep root /etc/* 2>/dev/null > grepout.txt
```

#### Using Pipes
* A pipe is a special case of redirection: It is applied to use the STDOUT of the first command as STDIN of the second command
* **ps aux | less**

### 2.3 Using Internal Commands

#### Understanding Internal Commands
* When working with Linux, external commands are commands that need to be fetched from disk
* To provide core functionality, Bash includes internal commands
* Internal commands are a part of the Bash binary and don't have to be loaded from disk
* Using internal commands is much faster than using external commands
* Type **help** for a list of all internal commands


### 2.4 Using Variables

#### Understanding Variables
* To have programs(including shell scripts) work with site-specific data, variables are used.
* Using variables allows an operating system to keep program code generic and separated from site-specific information
* The Linux operating system itself comes with variables
* Use **env** to print a list of these environment varaibles
* Best practice: To write efficient shell scripts, use variables a lot

#### Using Variables
* To define a variable, use **key=value**
* By default, variables will be available in the current shell only
* To define a variable for the current shell and all subshells, use **export key=value**
* To make sure a variable is automatically set, put it in one of the Bash startup files
* Refer to a variable using **echo $key**
* To avoid ambiguity, use **echo ${key}**; compare **echo${key}1** with echo **$key**

### 2.5 Working with alias

#### Understanding alias
* **alias** is a Bash internal command that allows you to define your own commands
* Best practice: Do NOT use alias in shell scripts, as alias settings are not universal and might not exist on other computers where the shell script is used
* unalias delete aliases

### 2.6 Understanding Bash Startup Files
* Bash startup files are used to provide default settings for the operating system environment
* These startup files are shell scripts themselves
* /etc/profile is a generic startup files that is started for every login shell
* /etc/bashrc is a generic startup file that is started when opening a subshell
* User specific files are
  * \~/.bash_profile
  * \~/.bashrc

### 2.7 Understanding Alternatives Shells
* The Bash shell goes back to shells that were created for use in UNIX in the 1970s
* Bourne shell (/bin/sh) was the original shell
* C-shell (/bin/csh) was developed as a shell that is very close to the C programming language
* Korne shell (/bin/ksh) was created as a shell that offers the best of Bourne and C-shell
#### Understanding Linux Shells
* Bash is Bourne Again Shell, a remake of the orignal Bourne shell that was invented in the early 1970's
* Bash is the default shell on most Linux distributions
* Another common shell is Zsh, which is used as the default shell on MacOS
* And yet another common shell is Dash, which is used frequently used on Debian
* While writing shell scripts, Bash is the standard and it's very easy to make Bash work, even if you're in a non-Bash shell


### 2.8 Understanding Exit Codes
* After execution, a command generates an exit code
* The last exit code generated can be requested using **echo $?**
* If 0, the command was executed sucessfully
* If 1, there was a generic error
* The developer of a program can be decide to code other exit codes as well
* In shell scripts, this is done by using **exit n** in case an error condition occurs
* You can use the man command to figure out if there any documentation related to the exit codes

#### Demo: exit codes

```bash
ls
# Request the state of the last command using the echo
echo $?
```

```bash
ls asdfasdf
echo $?
```

* Good idea is to check if there is exit code status using man
* Example man ls | grep -i Exit Status

### Lesson 2 Lab: Using Bash
* On your favorite working environment, open a terminal
* Type **echo $SHELL** to find which shell is currently used
* If this is not Bash, use **chsh -s /bin/bash** to make Bash the default shell
* Type **env** to get a list of current environment variables
* Type **cat /etc/profile | less** to print the contents of the /etc/profile file
* Type **alias** to get a list of aliases that are set
* Use **help** to show a list of internal commands

#### Lesson 2 Lab: Solution
<details>
  <summary>Lab 5 solution</summary>
  * Easy!
</details>


### 3.1 What is a Shell Script?
* A shell script is a computer program designed to run in a shell
* Scripts can be written in different scripting languages
* Typical functions are file manipulation, program executing and priting text

#### What's the use of Shell Scripts
* Shell scripts are part of the default working environment (shell)
* Shell scripts are strong in manipulating data
* You can use them, for instance, to filter ranges, change file names, and change data on a large scale easily
  * Shell scripts are easy to develop, and run from the leading Linux operating system
  * Shell scripts are commonly used in data science and other professional environments

### 3.2 What is a DevOps Environment?
* DevOps is a set of practices that combines software development(dev) with IT Operations (ops)
* The purpose of DevOps is to shorten the system development life cycle
* DevOps is a generic approach, which can be implemented in different ways
  * Toolchains
  * CI/CD pipelines
  * 12-factor application development
  * Deployment strategies

#### Understanding DevOps Toolchains
* In DevOps, toolchains are typically used to bring an application from source code to full operation
  * Coding
  * Building
  * Testing
  * Packaging
  * Releasing
  * Configuring
  * Monitoring

#### Understanding CI/CD Pipelines
* CI is Continuous Integration
* CD is Continuous Development
* CI/CD can be automated in a pipeline

#### Understanding 12-factor Apps
* The 12-factor App is methodology for building software-as-service apps that defines different factors which should be used in the apps

#### Why Shell Scripting Makes Sense in DevOps
* No matter which flow you're using in DevOps, it all comes down to processing files through different stages
* This is a task that can be done perfectly using shell scripts
* Shell scripts can pick up files, filter them, rename them and process them for further treatment using a wide range of tools that are native to the Linux operating system
* While using shell scripts in DevOps, it's important to develop them in an idempotent way

### 3.3 Bash and Other Shells
* Bourne Shell (/bin/sh) was released in 1979, and became the most important shell in version 7 UNIX
* Bash is Bourne Again Shell, and was developed as Bourne Shell next generation
* Zsh and Dash are other common shells on Linux

#### Understanding the C Shell
* C-shell (/bin/csh) was an important alternative to Bourne shell in years of UNIX
* The main benefit of csh, is that is offers a C language-like syntax
* A Bash was trying to offer compatibility to many other shells, some C syntax features are included in Bash as well
* For example, instead of using **echo** to print text, **printf** can be used

#### Undestanding Bash Script Compatibility
* Every shell comes with a specific feature set
* To ensure a Bash script is interprted the right way. it should start with **#!/bin/bash**
* The only requirement for this to work, is that the Bash shell must be installed on the current operating system

### 3.4 Shell scripts vs Automation
#### Understanding Automation
* In automation, tools like Ansible, Puppet, Chef and others are used to get managed systems in a desired state
* To do so, the desired state is described in a file, often written in YAML
* The automation tools compares the current state of manged systems to the desired state and takes action if needed 
* If not action is needed, nothing will happen
* Running Automation tool multiple times, should not lead to anything different implementation of the desired state; this feauture is known as indempotency
* Bash is not used to define desired state
* A Bash script defines actions to be accomplished
* Managing idempotency in Bash scripts is much harder to achieve
* Bash, however, is much more than configuration management; it's a programming language that helps in processing data, dealing with files, and running very specific tasks
* Automation doesn't replace the need for Bash scripts, both solutions are complimentary to each other

### 3.5 Shell scripts vs Python
#### Understanding Python
* Python is an object-oriented programming language that can be used for almost any purpose
* Python comes with many libraries that extend its functionality and make it useful in different environments
* Python also has more advanced debugginng tools and error handling feautures, which make it a better solution for writing bigger programs
* Bash scripts are using Bash shell, and for that reason are easier to program
* Core parts of Linux are written in Bash
* Bash can use commands line utilities without any modification
* Bash is part of the shell, and for that reason uses shell features in a more efficent way

### Lesson 3 Lab: Running a Bash Script in Zsh
* Set your current shell to **zsh** (whihout changing the default shell).
* Write a simple bash script that prints the text "hello world" on screen. Ensure that is executed as a Bash script, even if Zsh is the current scripting environment.

### 4.1 Using echo
* **echo** is a Bash internal that is used to print text on screen
* To use the formatting options, use **echo -e** and put the string between double quotes
  * **\b** is backspace: **echo -e "b\bc"**
  * **\n** is newline: **echo -e "b\nc"**
  * **\t** is tab: **echo -e "b\tc"**
* **printf** can be used as an alternative, but has its origin from the C-shell

### 4.2 Understanding **printf**
* **printf** is used to print text on screen, but has more formatting options than **echo**
* **printf** does not print a new line character by default, use **printf "%s\n" "hello world"** to print a new line
  * **"%s"** is the format string, **"\n"** is the newline formatting character
  * **"\t"** is also common and used to print tab stops
  * The format string is applied to all arguments used with **printf**
  * Compare the following commands:
    * **printf "%s\n" hello world**
    * **printf "%s\n" "hello world"**
    * **printf "%s\n" "hello" "world"**

#### Using **printf** Formatting Strings
* **"%s"** is used to identify the arguments as strings
* **"%d"** is used to identify the arguments as integers
* **"%f"** is used to identify the arguments as floats 
* While using formatting strings, further specifiers can be used
  * **printf "%f\n" 255**
  * **printf "%.1f\n" 255**
  * **for i in $(seq 1 10);do printf "%04d\t" "$i";done**

### 4.3 Using Bash Options
* The Bash shell can be configured with additional options, using **set**
  * **set -x**
  * **ls**
  * **set +x**
* Use **set** in a terminal to make it the standard behavior from that terminal 
* Use the set option directly after the shebang in a script to use it in a script only: **#!/bin/bash -x**

#### Using **shopt**
* Additinoal options can be configured from a script using **shopt**
  * **shopt +s extglob** enables extended globbing patterns
* Using these options allows you to add features to the shell and your scripts
  * **shopt -s checkjobs**
  * **sleep 3600 &**
  * **exit**
* Use **shopt** without arguments to print a list of current options

### 4.4 Using Patterns
* Regular expressions are patterns that are used by specific tools
* Globbing is for file patterns in Bash
* Basic globbing applies to standard features
  * \* matches zero or more characters
  * ? matches any single character
  * [...] matches any of characters listed.
* Extended globbing (must be enabled with **shopt +s extglob) provides additional options
  * ?(patterns): matches zero or one occurences of pattern
  * *(patterns): matches zero or more occurences of pattern
  * +(patterns): matches one more occurences of patterns
  * @(patterns): matches one occurence of pattern

#### Extended Globbing Examples
* **shopt +s extglob**
* **touch .txt e.txt ee.txt eee.ext**
* **ls *.txt**
* **ls ?(e).txt**
* **ls *(e).txt**
* **ls +(e).txt**
* **ls @(e).txt**

### 4.5 Using grep

#### Understanding grep
* **grep** is an external command that helps you filter text
* When using **grep**, it is recommended to put the text pattern you're searching for between single quotes to avoid interpretation by shell
  * **grep 'root'**
  * **ps aux | grep 'ssh'**
* **grep uses regular expressions, which are advanced text filters that help you find text patterns in a flexible way
* Examples:
  * **ps aux | grep 'cron' | grep -v 'grep'**
  * **grep -l 'root' * 2>/dev/null**
  * **grep -A 1 -B 1 'root' * 2>/dev/null**
  * **grep -r 'root' * 2>/dev/null**

### 4.6 Understanding Regular Expressions
* Regular Expressions are text patterns that are used by tools like grep and others
* _Always_ put your regex between single quotes!
* Don't confuse regular expressions with globbing (shell wildcards)!
* They look like file globbing, but they are not the same
  * **grep 'a*' a\***
* For use with specific tools only(**grep, vim, awk, sed**)
* See **man 7 regex** for details

#### Why Regular Expressions are Confusing
* Basic regular expressions work with most tools
* Extended regular expressions don't always work. Use **grep -E** if it is an extended regular expression
* Some scripting languages (like perl) come with their own regular expressions

#### Understanding Regular Expressions
* Regular expressions are built around _atoms_; an atom specifies what text is to be matched
  * Atoms can be a single characters, range of characters, or dot if you don't know the character
* The second element is the repetition operator, which specifies how many times a character should occur
* The third element is indicating where to find the next character
* Examples:
  * **^** beginning of the line: **grep '^l' myfile**
  * **\&dollar** end of the line: **grep 'anna$'**
  * **\\b** end of word: **grep '^lea\\b' myfile** will find lines starting with lea, but not with leanne
  * **\*** zero or more times: **grep 'n.\*x' myfile
  * **+** one or more times(extended regex!): **grep -E 'bi+t' myfile*&
  * **?** zero or more time (extended regex!): **grep -E 'bi?t' myfile**
  * **n\\{3\\}n** occurs 3 times: **grep 'bon\\{3\\}nen' myfile**
  * **.** one character: **grep '^.\$' myfile**

### 4.7 Using cut and sort
* **cut** allows you to filter out fields, based on a field separator: **cut -d : -f 1 /etc/passwd**
  * Use **awk** for more advance options
* **sort** allows you to sort items. Without any options, sort will happen based on the order of characters in the ASCII table
  * Use **sort -n** for numeric sort
  * Use **sort -d** for dictionary order
  * Many other useful option are available, consult the man page

#### Understanding IFS
* Commands like **cut**, and many more, work based on the Internal Field Separator (IFS)
* IFS by default is a space4
* Many commands have options to define the IFS that should be used
* cat /etc/passwd

### 4.8 Using tail and head
* **tail** and **head** are simple tools that allow you to print lines on top/bottom of a file

<<<<<<< HEAD
### 4.9 Using sed
* **sed** is the stream editor, which allows you to edit files even if no full screen is available
* **sed** is extremely rich, but in most cases only some core features are used
* **sed -n 5p /etc/passwd**
* **sed -i s/old/new/g ~/myfile**
* **sed -i -e '2d' ~/myfile**
* **for i in *conf;do sed -i 's/old/new/g' $i;done**
* pinfo sed has examples!

### 4.10 Using awk
#### AWK Examples
* **awk** is great to filter text: **awk -F:'{print $4}' /etc/passwd**
* same, but look for text "user":**awk -F: '/user/{prin t $4}' /etc/passwd**
* Only print field 1 if field 3 has a value bigger than 999: **awk -F: '$3>999 {print $1}' /etc/passwd**
=======
### 4.11 Considering External Tools and Performance

#### Best Pratice:Avoiding External Tools
* Best pratice: try to avoid using external tools
  * External tools and all the libraries they require need to be fetched from disk, which is relatively slow
  * Also, external tools are operating system specfic, sometimes even distribution specific, which makes your script less portable
* Use **type** to find out if a tools is external or not. Internal results can be **\<command\> is a shell keyword** or **\<command\> is a shell builtin** 
* To measure performance, use **time myscript** to measure the amount of time it takes to run a script with or without external tools
* you can check which libraries are using a command running **ldd $(which awk)

>>>>>>> d98dfdb1f871d10d5d21bff602a8697eb3c895d9

