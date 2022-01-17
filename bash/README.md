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
* Bash us Bourne Again Shell, a remake of the orignal Bourne shell that was invented in the early 1970's
* Bash is the default shell on most Linux distributions
* Another common shell is Zsh, which is used as the default shell on MacOS
* And yet another common shell is Dash, which is used frequently used on Debian

### 2.8 Understanding Exit Codes
* After execution, a command generates an exit code
* The last exit code generated can be requested using **echo $?**
* If 0, the command was executed sucessfully
* If 1, there was a generic error
* The developer of a program can be decide to code other exit codes as well
* In shell scripts, this is done by using **exit n** in case an error condition occurs

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