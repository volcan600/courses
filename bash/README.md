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
* bash -x ./script it used for debug or debugging

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
* 
### 4.11 Considering External Tools and Performance

#### Best Pratice:Avoiding External Tools
* Best pratice: try to avoid using external tools
  * External tools and all the libraries they require need to be fetched from disk, which is relatively slow
  * Also, external tools are operating system specfic, sometimes even distribution specific, which makes your script less portable
* Use **type** to find out if a tools is external or not. Internal results can be **\<command\> is a shell keyword** or **\<command\> is a shell builtin** 
* To measure performance, use **time myscript** to measure the amount of time it takes to run a script with or without external tools
* you can check which libraries are using a command running **ldd $(which awk)

### Lesson 4 Lab: Using Linux Commands
* Use the appropriate commands to create a list of all users on your Linux system that have a UID higher than 1000. The list needs to meet the following criteria:
* The full lines from /etc/passwd are printed
* The list is alphabetically sorted by username
* Any occurrence of /bin/bash us replaced with /bin/zsh
* Changes are not written to /etc/passwd but to /tmp/myusers

### Lesson 4 Lab Solution Using Linux Commands
<details>
  <summary>Lab 4 solution</summary>
* awk -F : '$3 > 999 { print $0 }' /etc/passwd | sort | sed 's/\/bin\/sh/\/bin\/zsh/' > /tmp/myusers
</details>

## Module 2: Shell Scripting Fundamentals

### 5.1 Choosing an Editor
* To write shell scripts, you need an editor
* This editor should offer syntax highlighting
* Any common editor offers syntax highlighting for shell scripting
* Commong Linux editor are **vim**, **gedit** and **nano**

### 5.2 Shell Scripts and IDEs
* An Integrated Development Environment (IDE) providees compehensive tools for programmers to develop software
* IDEs should at least contain the following:
  * Source code editor
  * Build automation tool
  * Debugger
* As shell scripts don't go through the normal cycle of software development, there are not IDEs have been developed specifically for shell scripting
* Just make sure you're using an editor with decent syntax highlighting

### 5.3 Core Bash Script Ingredients
* **Best practice:** make sure your scripts always include the following
  * Shebang: the indicator of the shell used to run the script code on the first line of the script:
    * **\#!/bin/bash** or **\#!/usr/bin/env bash** to identory Bash as the script interpreter
    * Comment to explain what the script is doing
    * White lines to increase readability
    * Different block of code to easily distinguish between parts of the script
#### About the Script Name
* Script names are arbitrary
* Extensions are not required but may be convenient for scripts users from non-Linux operating systems

#### About the Scripts Location
* Beacause of Linux $PATH restrictions, scripts cannot be executed from the current directory
* Consider using **~/bin** to store scripts for personal use
* Consider using **/usr/local/bin** for scripts that should be available for all users

### 5.1 Running the Scripts
* To run a script as a separate program, you need to set the execute permission: **chmod +x myscript**
* If the directory containing the script is not in the $PATH, run it using **./myscript**
* Scripts con also be started as an argument to the shell, in which case no execute permission and $PATH is needed: **bash myscript**
* **Best practice**: to avoid confusion, include a shebang on the first line of the script and put it in the $PATH so that it can run as an individual program

### 5.5 Finding Help About Scripting Components
* **help** provides an overview of Bash internal commands, which are the core components of any shell script
* **man bash** offers more detailed information about these commands
* Online resources offer additional information and examples: the Advanced Bash Scripting Guide (https://tldp.org/LDP/abs?html/) has been the key reference for many years

### Lesson 5 Lab: Writing your First Script
* Write a script that clears your screen and prints the message "hello world"
* Make sure this script meets all recommended syntax requirements
* Also make sure the scripts is in your computers $PATH in such a way that any user can execute it

### Lesson 5 Lab Solution Writing your First Script
<details>
  <summary>Lab 5 solution</summary>
    ```shell
    #!/bin/bash

    # This script clean and run hello world command
    clear

    echo  "Hello World"
    ```
</details>

### 6.1 About Terminology
* An _argument_ is anyting that can be put behind the name of a command or script
  * **ls -l /etc/** has 2 arguments
* An _option_ is an argument that changes the behavior of the command or script, and its functionality is programmed into the command
  * In **ls -l /etc, -l** is used as an option
* A _positional parameter_ is another world for an argument
* A _variable_ is a key with a name that can refer to a specific value
* While being handled, all are further thread as variables

### 6.2 Quoting
#### Understanding Quoting Option
* Escaping is the solution to take away special meaning from characters
* To apply escaping, use quotes
* Doble quotes are used to avoud interpretation of spaces
  * **echo "my value"**
* Single quotes are used to avoid interpretation of anything 
  * **echo the current '$SHELL' is $SHELL**
* Blackslash is used to avoid interpretation of the next character
  * **echo the current \$SHELL is $SHELL**

### 6.3 Defining and Using Variables
* A local variable works in the current shell only
* An environment variable is an operating system setting that is set while booting
* Arrays are special multi-valued variables 
  
#### Bash Variable Data Types
* Bash variables don't use data types
* Variables can contain number, character or a string of characters
* **declare** can be used to set specific variables attributes
  * **declare -r ANSWER=yes** sets $ANSWER as a read-only variable
  * **declare [a|-A] MYARRAY** is used to define an indexed or associative array
* Using **declare -p** to find out which type of variable something is:
  * compare **declare -p GROUPS** with **declare -p PATH**

#### Defining Variables
* Defining a variable can be easy: **key=value**
* Variable are not case sensitive
  * Environment variables, by default, are written in uppercase
  * Local variables can be written in any case
* After defining, a variable is available in the current shell only
* To make variables available in subshell also, use **export key=value**. It's only for subshells, you want it to be avaiable in all shells, put it on .bashrc
* To clear variable contents, use **key=** or use **unset**
* Use **env** to get access to environment variables

#### Using Variables
* To use the current value assinged to a variable, put a **$** in front of the variable name
* To better deal with variables, it is recomended, though not mandatory, to put the variable name between **\{ \}**
  * **color=red**
  * **echo $color**
  * **echo ${color}**
* To avoid confusion on specific types of variables, it is recommended, thought not mandatory, to put variable name between double quotes
* **echo "${color}"**

#### Special Variables
* Bash works with some special variables, that have an automatically assigned value
  * $RANDOM: a random number
  * $SECONDS: the number of seconds this shell has been running
  * $LINENO: the line in the current script
  * $HISTCMD: the number of this command in history
  * $GROUPS: an array that holds the names of groups that the current user is a member of
     * (compare **echo \$GROUPS** versus **echo "${GROUPS[@]}"**
  * $DIRSTACK: list of recently visited directories, also use **dirs** to display
* Apart from these, there are standard variables such $BASH_ENV, $BASHHOPTS and more

### 6.4 Defining Variables with read
* When **read** is used, shell script execution will stop to read user input
* The user input is stored in the variable that is provided as an argument to **read**
  echo enter a value
  read value
  echo you have entered $value
* If no variable name is set, the **read** result is stored in $REPLY
* **read** can also be used without futher arguments
* This can be useful for "Press Enter to continue" structures
  * echo press enter to continue
  * read
  * echo continuing...

#### Defining Multiple Variables with read
* **read** can be used to define more than one variable at the same time
  ```
    #!/bin/bash
    echo enter firstname, lastname and city
    read firstname lastname city
    echo nice to meet you $firstname $lastname from $city
  ```

### 6.5 Separating Code from Site Specific Data
* Code - including shell scripts - should be portable. It means to run on multiple shells
* That means that code should not include site specific information, which is referred to as decoupling
* To implement decoupling in shell scripts, variables should be defined in sepate files that are used by "sourcing" (including) then in the main script
* When a file is sourced, the contents of that file is included in the current shell, without starting a subshell

#### Using Source
* When sourcing variables, the files to be sourced should be stored separetly
* Some Linux distibutions are doing this by using an /etc/sysconfig directory
* To source a script, two approaches exists
  * **source myvars** will source the file
  * **.myvars** is an alternative way to do the same

### 6.6 Viewing Variables
* As variables can be set in different ways, viewing all curretly defined variables isn't easy
* **set** shows all current variables, including functions and the values of the variables
* **compgen -v** will show variables only and not their values

### 6.7 Handling Script Arguments

#### Understanding Script Arguments 
* Script can be started with arguments to provide specific values while executing the script
* _Arguments_ are also referred to as _Positional Parameters_
* The first argument is stored in $1, the second argument is stored in $2 and so on
* The script name itself is stored as $0
* By default, a maximum of nine arguments can be defined this way
* When using curly braces, more than nine arguments can be provided

#### Referring to Script Arguments
* Script arguments can be addressed individually
* To address all arguments, use **$\@** or **$\***
* Without quotes, **$\@** and **$\*** are indentical
* With quotes, **$\@** expands to properly quoted arguments, and **$\*** makes all arguments into a single argument

### 6.8 Using Shift
* **shift** is used to shift the positional parameters to the left
* **shift** can take a number as its arguments to shift the positinal parameters to the left by that number
* Using **shift** can be useful to remove arguments after processing them
* As an alternative, consider looping over all arguments using **while**

### 6.9 Using Command Substitution
* Command substitution is used to work the result of a command instead of a static value that is provided
* Use this to refer to values that change frequently:
  * **today=$(date +%d-%m-%y)**
  * **mykernel=$(uname -r)**
* Command substitution can be done in two ways that are not fundamentally different:
  * **today=$(date +%d-%m-%y)**
  * **today=\`date +%d-%m-%y\`

### 6.10 Using Here Documents
* A _here document_ is used as I/O redirection to feed a command list to an interactive program or command
* A _here_ document is used as scripted alternative that can be provided by input redirection
* Here documents are useful, as all the code that needs to be processed is a part of the script, ant there is no need process any external commands
* Example:
```bash
#!/bin/bash
lftp localhost << ENDSESSION
ls
put /etc/hosts
ls
quit
ENDSESSION
```

### 6.11 Using Functions

#### Understanding Functions
* A function is a small block of reusable code that can be called from the script by referring to its name
* Using functions is covenient when blocks of code are needed repeatedly
* Functions can be defined in two ways:
```bash
function_name () {
  commands
}

function function_name {

}
```
* Use **set** to show a list of all functions currently available

#### Using Function Arguments
* Functions can work with arguments, which have a local scope within the function
```bash
#!/bin/bash
hello () {
  echo hello $1
}
hello bob
```
* Function arguments are not affected by passing positinal parameters to a script while executing it

### Lesson 6 Lab: Working with Arguments and Variables
* Write a script that allows you to install and start any service. The name of the service should be provided as an argument while starting the script.
  
### Lesson 6 Lab Solution Working with Variables and Arguments
<details>
  <summary>Lab 6 solution</summary>
    ```bash
    #!/bin/bash

    if [ -z $2 ]
    then
            echo program name was not enter
            exit 9
    fi

    # Indentify distribution
    if grep -i 'ubuntu' /etc/os-release >/dev/null
    then
            PACKAGE_MANAGER=apt
    elif grep -i 'centos' /etc/os-release >/dev/null
    then
            PACKAGE_MANAGER=yum
    fi

    # update package manager
    sudo $PACKAGE_MANAGER update -y

    # install package
    sudo $PACKAGE_MANAGER install -y $1

    # echo starting service
    sudo systemctl start $1
    ```
</details>

### 7.1 Working with Parameter Substitution
* Parameter substitution can be used to deal with missing parameters
* Use it to set a default, or to display a message in case missing parameters were found
```bash
#!/bin/bash

echo enter username or press enter to use default value
read username
echo ${username:-$(whoami)}
```

#### Using Parameter Substitution
* If parameter is not set, use default (does NOT set it)
  * **echo ${username:-$(whoami)}** uses result of whoami if $username is not set
  * **filename=${1:-$DEFAULT_FILENAME}** uses values of $DEFAULT_FILENAME if $filename is not set
* If parameter is not set, set default
  * **echo ${username:=$(whoami)}** uses eresult of whoami if $username if not set
  * **filename=${1:=$DEFAULT_FILENAME}** uses value of $DEFAULT_FILENAME if $filename is not set
* If parameter is not set, print error_msg and exit script with exit status 1
  * **echo ${myvar:?error_msg}**
```bash
#!/bin/bash
echo take one
echo ${var:-abc}
echo ${var}

echo take two
echo ${var:=abc}
echo ${var}
```
* example two
``` bash
#!/bin/bash

echo check for existence of essential variables
: ${HOSTNAME?} ${USER?}
echo if you see this step 1 worked

${COW?}
echo you shouldnt see this
```
* example tree
```bash
#!/bin/bash
echo ${1-?"Usage: $0 Argument"}
echo string length of the argument is ${#1}
```

### 7.2 Using Pattern Matching Operators
* The purpose of a pattern matching operator is to clean up a string
* **${1#}** prints the string length of $1
* **${1#patern}** removes the shortest match of pattern from the front end of $1
* **${1##patern}** removes the longest match of pattern from the fron of $1
* **${1%patern}** removes the shortest match of pattern from the back end of $1
* **${1%%patern}** removes the longest match of pattern from the back end of $1

#### Understanting Variable String Replacement
* **${var/pattern/replacement}** is used to replace a pattern inside a variable
* **${var//pattern/replacement}** perform a global replacement
* **${var/#pattern/replacement}** will only replace if the variable starts with pattern
* **${var/%pattern/replacement}** will only replace if the variable ends with pattern

### 7.3 Using Patterns and Extended Globbing
* Extended globbing can be used to analyze file patterns in a smart way
* See **patternglob** in the course Git repository
* See **removepattern** in the course Git repository

### 7.4 Calculating
* Bash offers different solutions for calculation with integers:
  * **let expression**
  * **expr expression**
  * **$((expresion))**
* Of these 3, the $((...)) method is preferred
* All work with the following operators
  * +
  * -
  * \*
  * /
  * %

#### Bash Calculation Examples
* **let** is bash internal
  * **let a=1+2**
  * **echo $a**
  * **let a++**
  * **echo $a**
* **expr** is an external command that can be used in scripts, but it is not used much anymore
* **$((...))** allows you to put the calculation between parenthesis 
  * **echo $((2 * 3))**

#### Advanced Calculation Tools
* **bc** is an advanced calculation tool that allows you to work with decimals
  * **bc** is typically used in pippes: **echo "12/5" | bc**
  * to print decimals in the result, use **-l: echo "12/5" | bc -l**
  * **bc** also offers access to built-in mathematical functions: **echo "sqrt(1000)" | bc -l**
* **factor** decomposes an integer into prime factor
  * **factor 399**

### 7.4 Using tr
* **tr** is an external utility allows for translation of characters
  * **echo hello | tr [a-z] [A-Z]**
  * **echo hello | tr [:lower:][:upper:]**
  * **echo how are you | tr [:space:] '\t'**

#### Change Case in Variables
* Bash variables can modify case using ^^(uppercase) and ,,(lowercase)
  * **color=red;echo ${color^^}**
  * **color=BLUE;echo ${color,,}**

### Lesson Lab Transforming Input
* You have performed a wring scripting manipulation, and as a result all files have been renamed with the extension .txt. Write a script that renames the file to the filename without the extension.

### Lesson 7 Lab Solution Transforming Input
<details>
  <summary>Lab 7 solution</summary>
    ```bash
    #!/bin/bash

    for i in *
    do
        mv $i ${i%.*}
    done
    ```
</details>

### 8.1 Using test
* **test** is the foundation of many **if** statements
* **test** is an external command that allows you to perform different types of test
  * Expression tests: test can evaluate the binary outcome of an expression, which is a logical test by itself
  * String tests: allow you to evaluate if a string is present or absent, and compare one string to another
  * Integer tests: allow you to compare integers, which includes operations like bigger than, smaller than
  * File tests: allow you to test all kind of properties of files
* **test** is typically used in conditional statements
* **test condition** can also be written as **[ condition ]**

#### Using Simple **if** Statements
* **if** used to verify that a condition is true
```bash
if true
then
  echo command executed successfully
fi
```
* The condition is a command that returned an exit code 0, or a test that completed successfully:
  * **if [ -f /etc/hosts ]; then echo file exists;fi**

#### Using **||** and **&&**
* Logical test are **if then else** tests written in a different way
* Logical AND: the structure is **a && b**, which results in **b** being executed when **a** is successful
* Logical OR: the structure is a **a || b**, which results in **b** being executed only if **a** is not successful
* Logical operators can be embedded in **if** statements to test multiple conditions
  * **if [ -d $1 ] && [ -x $1 ];then echo $1 is a directory and has execute;fi**

#### Rewriting **if** Statements to Logical Test
```bash
if [ -f /etc/hosts ]
then
    echo file exists
fi
```
```bash
[ -f /etc/hosts ] && file exists
```

#### Understanding **[[condition]]**
* A regular test is written as **[ condition ]**
* The enhanced version is written as **[[ condition ]]**
* **[[ condition ]]** is a Bash internal, and offers features not offered by **test**
* Because it is a Bash internal, you may not find it in other shells
* Because of the lack of compatibility, many scripters prefer using **test** instead

#### **[[ condition ]] Examples
* **[[$VAR1 = yes && $VAR2 = red ]]** is using a conditional statement within the test
* **[[ 1<2 ]]** tests if 1 is smaller than 2
* **[[ -e $b ]]** will test is $b exists. If $b is a file that contains spaces, using [[]] won't require you to use quotes
* **[[ $var = img* && ($var = *.png || $var = *.jpg)]] && echo $var starts with img and ends with .jpg or .png**

### 8.5 Using if...then...else
* **else** can be used as an extension to **if** statements to perform an action of the first condition is not true
* Notice that instead of using **else**, independent statements can be used in some cases
* See the differences between **else1** and **else2** in the course Git repo
```bash
#!/bin/bash
if [ -z $1 ]
then
    echo no argument provided please try again
    exit 1
fi
echo you only get here if an argument was provided
```

### 8.6 Using if...then...else with elif
* **elif** can be added to the **if...then...else** statements to add a second condition
```bash
#!/bin/bash
if [ -d $1 ];then
  echo $1 is a directory
elif [ -f $1 ];then
  echo $1 is a file
else
  echo $1 is an unknown entity
fi
```

### Lesson 8 Lab Using if...then...else
* Write a script that will alert if available disk space on the / partition or volume is less than 3GB, or if less than 512 MB RAM is listed as free.
* If both of these conditions are true, the script should print: WARNING: low system resource.
* If only low disk space is available, the script should print: WARNING: low disk space available
* If only low memory is available, the script should print WARNING: low memory available
* If neither of these low conditions is the case, the script should print the message: all is good

### Lesson 8 Lab Solution Using if...then...else
<details>
  <summary>Lab 8 solution</summary>
    ```bash
    #!/bin/bash

    # set variables to contain vales
    DISKFREE=$(df -m | grep '/$' | awk '{ print $4 }' )
    MEMFREE=$(free -m | grep Mem | awk '{ print $4 }' )

    echo DISKFREE
    echo MEMFREE
    # Check if disk AND memory are low
    if [ $DISKFREE -le $(( 1024 * 3 )) && $MEMFREE -le 512 ]
    then
        echo WARNING: low system resources
        exit 9
    fi
    
    # Check if only disk is low
    if [$DISKFREE -le $(( 1024 * 3 ))]
    then
        echo WARNING: low disk space
        exit 8
    fi

    # check if only memory is low
    if [$MEMFREE -le 512 ]
    then
        echo WARNING: low memory detected
        exit 7
    fi

    # print message of all is good
    echo your system resources are all fine
    ```
### 9.1 Applying Conditionals and Loops
* **if...then...else** is used to execute commands if a specific condition is true
   * **[ -z $1 ]; then echo hello;fi**
* **for** is used to execute a command on a range of items
   * **for i in "$@"; do echo $i;done**
* **while** is used to run a command as long as condition is true
  * **while true;do true;done**
* **until** is used to run a command as long as a condition is not true
  * **until who | grep $1;do echo $1 is not logged in;done**
* **case** is used to run a command if a specific situation is true

### 9.2 Using for
* **for** is used to iterate over a range of items
* This is useful for handling a range of argumments, or a series of files
* Example:
```bash
for i in {115...127}; do echo $i; done
for i in {115...127}; do ping -c 192.168.100.$i; done
```

### 9.3 Using case
* **case** is used to check a specific number of cases
* It is useful to provide scripts that work with certain specific arguments
* It has been used a lot in legacy Linux init scripts
* Notice that **case** is case sentive, consider using **tr** to convert all to a specific case
* Example:
```bash
echo are you good?

read GOOD

GOOD=$(echo $GOOD | tr [:upper:] [:lower:])

case $GOOD in
yes|oui)
        echo that\'s nice
        ;;
no)
        echo that\'s not so nice
        ;;
*)
        echo okay
        ;;
esac
```
### 9.4 Using while and until
* **while** and **until** are used to run a command based on the exit status of an expression
* **while** will run the command as long the expression is true
* **until** will run the command as long as the expression is not true
Examples:
```bash
#!/bin/bash
# until example
until who |grep lind
do
  echo user not logged in
  sleep 5
done

echo user just logged in

# while
while true, do true; done
```

### 9.5 Using break and continue
* **break** is used to leave a loop straight away
* Using **break** is useful if an exceptional situation arises
* **continue** is used to stop running through this iteration and begin the next iteration
* Using **continue** is useful if a situation was encontered that makes it impossible to proceed
*  Break example:
```bash
#!/bin/bash
# backup script that stops if insufficient disk space is available
if [ -z $1 ]
then
    echo enter the name of a directory to back up
    read dir
else
    dir=$1
fi

[ -d ${dir}.backup ] || mkdir ${dir}.backup
for file in $dir/*
do
  used=$( df $dir | tail -1 | awk '{ print $5 }' | sed 's/%//' )
  if [ $used -gt 98 ]
  then
      echo stopping: low disk space
      break
  fi

  cp $file ${dir}.backup
done
```
* Continue example:
```bash
#!/bin/bash

# convert file names to lower case if required

FILES=$(ls)

for file in $FILES
do
        if [[ "$file" != *[[:upper:]]* ]]; then
                echo "$file" doesn\'t contain uppercase
                continue
        fi

        OLD="$file"
        NEW=$(echo $file | tr '[:upper:]' '[:lower:]')

        mv "$OLD" "$NEW"
```

### Lesson 9 Lab: Using Conditionals and Loops
* Write a script that can be used to install, start and enable services
* The names of the services must be provided as command line arguments.
* If no command line arguments were provided while starting the script, the script should show an error message.
* Before starting the next service, the script should check that at least 256MB of RAM is still available. If that is not the case, the script should stop.

### Lesson 9 Using Conditionals and Loops
<details>
  <summary>Lab 9 solution</summary>
    ```bash
    #!/bin/bash
    if [ -z $1 ]
    then
          echo you have to provide at least one argument
          exit 3
    fi
    
    MEMFREE=$(free -m | grep Mem | awk '{ print $4 }')

    if [ $MEMFREE -lt 256 ]
    then
          echo insufficient memory available
          exit 4
    fi

    # install start and enable services
    sudo apt install -y "$@"

    for s in "$@"
    do
          sudo systemctl enable --now $s
    done
    ```
### 10.1 Working with Options
* An _option_ is an argument that changes script behavior
* Use **while getopts "ab:" opts** to evaluate options a and b, and while evaluating them, put them in a temporary variable opts
* Next, use **case $opts** to define what should happend if a specific option was encountered
```bash
#!/bin/bash
while getopts "hs:" arg; do
case $arg in
        h)
                echo "usage"
                ;;
        s)
                strength=$OPTARG
                echo $strength
                ;;
        esac
done
```

```bash
#!/bin/bash
#makeusr [-u uid] [-g gid] [-i info] [-h homedir] [-s shell] username
        function usage
        {
                        echo ‘usage: makeusr [-u uid] [-g gid] [-i info] [-h homedir] ‘
                        echo ‘[-s shell] username
                        exit 1
        }

        function helpmessage
        {
                        echo "makeusr is a script ... "
                        echo "blablabla"
        }

        while getopts "u:g:i:h:s:" opt; do
                        case $opt in
                                u ) uid=$OPTARG ;;
                                g ) gid=$OPTARG ;;
                                i ) info=$OPTARG ;;
                                h ) home=$OPTARG ;;
                                s ) shell=$OPTARG ;;
                                ? ) helpmessage ;;
                                * ) usage ;;
                        esac
        shift $(($OPTIND -1))
        done

        if [ -z "$1" ]; then
                        usage
        fi

        if [ -n "$2" ]; then
                        usage
        fi

        if [ -z "$uid" ]; then
                        uid=500
                        while cut -d : -f3 /etc/passwd | grep -x $uid
                        do
                                uid=$((uid+1)) > /dev/null
                        done
        fi

        if [ -z "$gid" ]; then
                        gid=$(grep users /etc/group | cut -d: -f3)
        fi

        if [ -z "$info" ]; then
                        echo Provide information about the user.
                        read info
        fi

        if [ -z "$home" ]; then
                        home=/home/$1
        fi

        if [ -z "$shell" ]; then
                        shell=/bin/bash
        fi

        echo $1:x:$uid:$gid:$info:$home:$shell >> /etc/passwd
        echo $1:::::::: >> /etc/shadow
        mkdir -p $home
        chmod 660 $home
        chown $1:users $home
        passwd $1
```

### 10.2 Using Variables in Functions
* No matter where they are defined, variables always have a global scope even if definedin a function
* Use the **local** keyword to define variables with a local scope inside of a function
* See **funcvar** for an example
* Example:
```bash
#!/bin/bash
var1=A

my_function () {
        local var2=B
        var3=C
        echo "inside function: var1: $var1, var2: $var2, var3: $var3"
}

echo "before runninng function: var1: $var1, var2: $var2, var3: $var3"

my_function

echo "after running function: var1: $var1, var2: $var2, var3: $var3"
```

### 10.3 Defining Menu Interfaces
* The **select** statement can be used to select a menu
* Use **PS3** to define a menu prompt
* The **select** statement embeds a **case** statement
* After executing a menu option, you will get back to the menu
* Use **break** to get out of the menu
* **$REPLY** is a default variable that contains the string that was entered at the prompt
* The select statment can refer to the choices directly. If the choices contain spaces, you'll need to use an array instead
* Example:
```bash
#!/bin/bash

PS3='Enter your choice: '
options=("Option 1" "Option 2" "Option 3" "Quit")

select opt in "${options[@]}"
do
        case $opt in
                "Option 1")
                        echo "you have selected option 1"
                        ;;
                "Option 2")
                        echo "you have selected option 2"
                        ;;
                "Option 3")
                        echo "you have selected $REPLY with is $opt"
                        ;;
                "Quit")
                        break
                        ;;
                *) echo "invalid option $REPLY";;
        esac
done
```

### 10.4 Using trap
* **trap** is used to run a command while catching a signal
* **SIGKILL (kill -9)** cannot be trapped
* Signals are specific software interrupts that can be sent to a command
* Use **man 7 signal** or **trap -l** for an overview
####
* **trap** is useful to run commands upon receiving a signal
* Use it to catch signals that you don't want to happen in the script, like INT
* Or use it on EXIT, to define tasks that should happen when the script properly exists
  * This is stonger that just running a comand at the end of the script, because that will only run if the script reaches the end
* Example:
```bash
#!/bin/bash
trap "echo ignoring signal" SIGINT SIGTERM
echo pid is $$

while :
do
        sleep 60
done
```
* Example two:
```bash
#!/bin/bash
tempfile=/tmp/tmpdata
touch $tempfile
ls -l $tempfile
trap "rm -f $tempfile" EXIT
```

### Lesson 10 Lab Writing a Menu
* Write a menu with the name operator. It should meet the following requirements:
  * The menu offers options to see available disk space, available RAM and users currently logged in
  * It should not be possible to exit from the menu using Ctrl-C

### Lesson 10 Lab Writing a Menu
<details>
  <summary>Lab 10 solution</summary>
    ```bash
    #!/bin/bash

    PS3="Enter your choice:"
    option=("See Disk Space" "Check Memory" "List current users" "Quit")

    trap "ignoring ctrl-c" SIGINT
    
    select opt in "${options[@]}"
    do
            case $opt in
                    "See Disk Space")
                            df -h
                            ;;
                    "Check Memory")
                            free -m
                            ;;
                    "List current user")
                            who
                            ;;
                    "Quit")
                            break
                            ;;
                    *) echo "invalid option $REPLY";;
            esac
    done
    ```

### 11.1 Understanding Why Arrays are Useful
* The string is the default type of parameter
* Integers are parameter types that can be used in calculations
* An array is a parameter that can hold multiple values, stored as key/value pairs, where each value can be addressed individually
* Strings may contain multiple elements, but there is no way that always works to find all these elements
* Particularly, files containing spaces in their names have issues
  * string: **file=$(ls *.doc);cp $files~/backup**
  * array: **files=(*.txt);cp "${files[@]}"~/backup**
* To ensure that lists of things that need to be processed always work, use arrays

### 11.2 Understanding Array Types
* _index arrays_ address a value by using an index number
  * Index arrays are very common
  * The **declare** command does not have to be used to define an index array
* Associative arrays address a value by using a name
  * Associative arrays provide the benefit of using meaningful keys
  * Associative arrays are relatively new
  * While using associative arrays, you must use **declare -A**

### 11.3 Using Arrays
* Indexed arrays are the most common, and are defined much like variables, where all elements are put between braces
* In the indexed array, the key is an index value, starting with index value 0
  * my_array=(one two three)
* Don't confuse with command substitution
  * myname=$(whoami)
* Associative arrays exists since Bash 4.0: they use user-defined strings as the key
  * ${value[XLY]}
  * Ordering in associative arrays can not be guaranteed!
#### Using Arrays
* Arrays should always be used with quotes, without quotes you'll lose the array benefits and your script may fail over spaces
* **"${myarray[@]}"** refers to all values in the array
* **"${myarray[1]}"** refers to index value 1 (the second element)
* **"${!myarray[@]}"** refers to all keys in the array
* Example:
```bash
#!/bin/bash
my_array=( a b c )

# print index value 1
echo ${my_array[1]}

# print all items in the array
echo ${my_array[@]}
echo ${my_array[*]}

# print all index values and not their value
echo ${!my_array[@]}

# print the length of the array
echo ${#my_array[@]}

# loop over all items in the array; printing all keys as well as all values
for i in "${!my_array[@]}"
do
        echo "$i" "${my_array[$i]}"
done

# loop on just the values and not the keys
for i in "${my_array[@]}"
do
        echo "$i" 
done

# adding a value at a specific position
# using 9 to make sure it is last
my_array[9]=d
echo ${my_array[@]}
echo ${my_array[9]}

# adding items to the end of the array, using the first available index
my_array+=( e f )
for i in "${!my_array[@]}"
do
        echo "$i" "${my_array[$i]}"
done
```
#### Using **declare** to Define Arrays
* To create an indexed array, you can just start by assigning values to it
  * **my_array=(cow goat)**
* Optionally, you can declare it using **declare -a**
* To create an associative array, you need to use **declare -A**
  * **declare -A my_aaray**
  * **my_aaray=([value1])=cow [value2]=sheep)**

### 11.4 Reading Command Output into Arrays
* Use **mapfile** to fill an array with the result of a command
  * **mapfile -t my_array <<(my_command)**
* Otherwise, you can use a loop that adds each item in the output item-by-item
```bash
my_array=()
while IFS=read -r line;do
    my_array+=($"line")
done<<(my_command)
```
* **IFS** sets the internal Field Separator to a space for just the **read** command
* **read -r** tells read not to interpret backslashes as escape characters
* As long as elements are found in **my_command**, the loop continues
* Example:
```bash
#!/bin/bash

# scanning hosts on $NETWORK
echo enter the IP address of the network that you want to scan for available hosts
read NETWORK

# enabling some debugging so that we see what happens
set -x 
hosts=()
# below IFS is set at the same line as the read statement to make sure it affects the read statement only
# IFS is set to a space to make sure that as long as it finds a space after an item the script continues
while IFS= read -r line; do
        hosts+=( "$line" )
done < <( nmap -sn ${NETWORK}/24 | grep ${NETWORK%.*} | awk '{ print $5 }')
set +x

# the two lines below are for debugging only
echo press enter to continue
read

# and here we check that the array works as intended
for value in "${hosts[@]}"
do
        echo $value
done
```
### 11.5 Reading Command Output into Arrays- Alternative Approach
* Example:
```bash
#!/bin/bash

# generating SSH key for local user
[ -f $HOME/.ssh/id_rsa ] || ssh-keygen

# scanning hosts on $NETWORK
echo enter the IP address of the network that you want to scan for available hosts
read NETWORK

# you can fill an array with command output in two ways. The lines below are not as efficient but also work
#hosts=()
#while IFS= read -r line; do
#       hosts+=( "$line" )
#done < <( nmap -sn ${NETWORK}/24 | grep ${NETWORK%.*} | awk '{ print $5 }')

# alternative notation
mapfile -t hosts < <(nmap -sn ${NETWORK}/24 | grep ${NETWORK%.*} | awk '{ print $5 }')

# this line shows debug information; useful while developing but can be removed now
for value in "${hosts[@]}"
do
        echo $value
done

PS3='which host do you want to setup? (Ctrl-C to quit) '
select host in "${hosts[@]}"
do
        case $host in
                *)
                        echo you selected $host
                        set -v
                        ssh-copy-id root@$host
                        scp /etc/hosts root@$host:/etc
                        set +v
                        echo this is enough for the proof of concept script
                        ;;
        esac

done
```

### 11.6 Looping through Arrays
* Example:
```bash
#!/bin/bash
# poem.sh: Pretty-prints one of the ABS Guide author's favorite poems.
# credits: TLDP Advanced Bash Scripting Guide

# Lines of the poem (single stanza).
Line[1]="I do not know which to prefer,"
Line[2]="The beauty of inflections"
Line[3]="Or the beauty of innuendoes,"
Line[4]="The blackbird whistling"
Line[5]="Or just after."
# Note that quoting permits embedding whitespace.

# Attribution.
Attrib[1]=" Wallace Stevens"
Attrib[2]="\"Thirteen Ways of Looking at a Blackbird\""
# This poem is in the Public Domain (copyright expired).

echo

tput bold   # Bold print.

for index in 1 2 3 4 5    # Five lines.
do
  printf "     %s\n" "${Line[index]}"
done

for index in 1 2          # Two attribution lines.
do
  printf "          %s\n" "${Attrib[index]}"
done

tput sgr0   # Reset terminal.
            # See 'tput' docs.

echo

exit 0
```

### Lesson 11 Lab: Using Arrays
* Use arrays to write a roster script. The script should do the following:
  * For each day of the week, prompt the user "enter janitor name for day"
  * Store the names in an associative array, where weekdays are used as the key, and janitor names as the value
  * After prompting for the janitor names, the script should print the roster for this week

### Lesson 11 Lab: Using Arrays Solution
<details>
  <summary>Lab 11 solution</summary>
    ```bash
    #!/bin/bash

    # use readarray to create the associative names
    echo enter name for monday
    read name1
    echo enter name for tuesday
    read name2
    echo enter name for wednesday
    read name3
    echo enter name for thursday
    read name4
    echo enter name for friday
    read name5
    echo enter name for saturday
    read name6
    echo enter name for sunday
    read name7

    declare -A roster
    roster[monday]=$name1
    roster[tuesday]=$name2
    roster[wednesday]=$name3
    roster[thursday]=$name4
    roster[friday]=$name5
    roster[saturday]=$name6
    roster[sunday]=$name7

    # print the names of responsible janitor for each day
    for i in "${!roster[@]}"
    do
      echo "$i" "${roster[$i]}"
    done
    ```
    ```bash
    #!/bin/bash

    # use readarray to create the associative names
    echo enter names for Janitors from Mon-Sun \(seven names required\)
    read name1 name2 name3 name4 name5 name6 name7

    declare -A roster; declare -a order
    roster[monday]=$name1; order+=( "monday" )
    roster[tuesday]=$name2; order+=( "tuesday" )
    roster[wednesday]=$name3; order+=( "wednesday" )
    roster[thursday]=$name4; order+=( "thursday" )
    roster[friday]=$name5; order+=( "friday" )
    roster[saturday]=$name6; order+=( "saturday" )
    roster[sunday]=$name7; order+=( "sunday" )

    # print the names of responsible janitors for each day
    for i in "${order[@]}"
    do
            echo "$i" "${roster[$i]}"
    done
    ```
### 12.1 Developing Step-by-Step
* Star writing the bigger structure of the script, using comment signs
* Next, write and test each part of the script separately
* While doing so, try not to use commands that change anything, use **echo** instead
* Use white lines to keep the script readable

### 12.2 Using set Options
* Bash **set** can be used in a script to enable/disable specific functionality
  * **set** options can be specified in two ways: using an option, or using **set -o option-name**
  * compare **set -e** and **set -o errexit**
* Use **set -x** to enable an option
* Use **set +x** to disable an option
  * **-e**: Exit the script when a commands fails
  * **-i**: runs the script in interactive mode
  * **-v**: runs a script in verbose mode
  * **-x**: runs a script in verbose mode while expanding commands
### Placing set Commands
* The advantage of **set** is that you can enable an option before a specific section and disable it again after that section
* Example:
```bash
#!/bin/bash

set -e

false
echo do we see this
```
### 12.3 Including Debug Information
* As discussed before, options can be used to make a script more verbose
* Alternatively, the scripter can manually include debug information at critical points
* To do so, use **echo** and **read**
  * **echo just added the user, press enter to continue**
  * **read**
* Notice that **read** is used without further argument, as the answer to the **read** prompt is not used anyway
* Use manually inserted debug information while developing, and don't forget to clean up once done
#### Using echo
* While testing script, consider using **echo** with all commands you want to use
* Using **echo** avoids your script from making modifications to the system, once confirmed that all works as expected, you can clean up the **echo** statements

### 12.4 Writing Debug Information to a File
* When using **bash -x**, debug information is sent to STDERR
* Since Bash 4.1, the BASH_XTRACEFD variable can be set to write debug inforamtion to a file
* This variable defines a file descriptor that is next redirected to a specific file
* When using BASH_XTRACEFD, you'll need a custom file descriptor
* To define this custom file descriptor, use **exec**
* **exec 15>myfile** is sending all that is sent to FD 15 to the file myfile
* Next, BASH_XTRACEFD is assigned to use this file descriptor
* Example:
```bash
#!/bin/bash

# Use FD 15 to capture the debug stream caused by "set -x":
exec 15>/tmp/bash-debug.log
# Tell bash about it  (there's nothing special about 15, its arbitrary)
export BASH_XTRACEFD=15

# turn on debugging:
set -x

# run some commands:
cd /etc
find 
echo "that was it"

# Close the debugging:
set +x

# Close the file descriptor
exec 15>&-

# See what we got:
cat /tmp/bash-debug.log
```
### 12.5 Running bash -x
* Instead of using the **set** option, you can use **bash -x** from the command line
* Using **bash -x** is not as elegant, as it will debug the entire script and you might just want to focus on a specific section
* The benefit however is that you don't have to modify the script code while using **bash -x** 

### Lesson 12 Lab  Using Debug Techniques
* Script11 contains a few errors. Use the appropriate debug techniques to fix it
* Examples: 
```bash
#!/bin/bash

COUNTER=$1
COUNTER=$(( COUNTER * 60 ))

minusone()({
        COUNNTER=$(( COUNTER - 1 ))
        sleep 1
}

while [ $COUNTER -gt 0 ]
do
        echo you still have $COUNTER seconds left
        minusonne
done

[ $COUNTER = 0 ] && echo time is up && minusone
[ $COUNTER = "-1" ] && echo you now are one second late && minusone

while true
do
        echo you now are ${COUNTER#-} seconds late
        minusone
done
```
### Lesson 11 Lab: Using Arrays Solution
<details>
  <summary>Lab 11 solution</summary>
    ```bash
    #!/bin/bash

    COUNTER=$1
    COUNTER=$(( COUNTER * 60 ))

    minusone(){
            COUNTER=$(( COUNTER - 1 ))
            sleep 1
    }

    while [ $COUNTER -gt 0 ]
    do
            echo you still have $COUNTER seconds left
            minusone
    done

    [ $COUNTER = 0 ] && echo time is up && minusone
    [ $COUNTER = "-1" ] && echo you now are one second late && minusone

    while true
    do
            echo you now are ${COUNTER#-} seconds late
            minusone
    done
    ```

### 13.1 Monitoring CPU Utilization
```bash
#!/bin/bash
# Script that monitors the top-active process. The script sends an email to the user root if
# utilization of the top active process goed beyond 80%. Of course, this script can be tuned to 
# do anything else in such a case.
#
# Start the script, and it will run forever.

while true
do
        # Check every 60 seconds if we have a process causing high CPU load
        sleep 60
        USAGE=`ps -eo pcpu,pid -o comm= | sort -k1 -n -r | head -1 | awk '{ print $1 } '`
        USAGE=${USAGE%.*}
        PID=`ps -eo pcpu,pid -o comm= | sort -k1 -n -r | head -1 | awk '{print $2 }'`
        PNAME=`ps -eo pcpu,pid -o comm= | sort -k1 -n -r | head -1 | awk '{print $3 }'`

        # Only if we have a high CPU load on one process, run a check within 7 seconds
        # In this check, we should monitor if the process is still that active
        # If that's the case, root gets a message
        if [ $USAGE -gt 80 ] 
        then
                USAGE1=$USAGE
                PID1=$PID
                PNAME1=$PNAME
                sleep 7
                USAGE2=`ps -eo pcpu,pid -o comm= | sort -k1 -n -r | head -1 | awk '{ print $1 } '`
                USAGE2=${USAGE2%.*}
                PID2=`ps -eo pcpu,pid -o comm= | sort -k1 -n -r | head -1 | awk '{print $2 }'`
                PNAME2=`ps -eo pcpu,pid -o comm= | sort -k1 -n -r | head -1 | awk '{print $3 }'

                # Now we have variables with the old process information and with the
                # new information

                [ $USAGE2 -gt 80 ] && [ $PID1 = $PID2 ] && mail -s "CPU load of $PNAME is above 80%" root@blah.com < .
        fi
done
```

### 13.2 Rebooting and Picking up After Reboot
* For some tasks, complety different scripted solutions can be developed
* Consider the 2 scripts developed to pick up tasks after a system reboot
* One of the scripts has a more traditional approach, whereas the other script interfaces with systemd
```bash
cat << REBOOT > /usr/local/completeme.sh
#!/bin/bash
echo DONE > /tmp/after-reboot
systemctl disable completeme
REBOOT
chmod +x /usr/local/completeme.sh
cat << SERVICE > /etc/systemd/system/completeme.service
[unit]
Description=CompleteMe

[Install]
Type=simple
WorkingDirectory=/usr/local
ExecStart=/usr/local/completeme.sh
SERVICE

systemctl daemon-reload
systemctl enable completeme

reboot
```

### 13.3 Using Advanced Pattern Matching Operators
* Pattern Matching Operators can be used to remove patterns from the beggining, or from the end of a string
* But how would you remove a pattern from the middle?
```bash
#!/bin/bash
#
# displays current day, month, year
DATA=$(date +%d-%m%)