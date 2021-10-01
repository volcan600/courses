# Bash Shell Scripting

## Module 1: Before Writing your First Shell Script
* Lesson 1: Setting up the Course Environment
  * 1.1 Installing Ubuntu Linux
  * 1.2 Installing Red Hat Linux
  * 1.3 Using Windows Subsystem for Linux
  * 1.4 Using the Bash Shell in MacOs
* Lesson 2: Getting Familiar with Bash
  * 2.1 Understanding the Role of Bash
  * 2.2 Using STDIN, STDOUT, STDERR and I/O Redirection
  * 2.3 Using Internal Commands
  * 2.4 Using Variables
  * 2.5 Working with alias
  * 2.6 Using Bash Startup Files
  * 2.7 Understanding Alternative Shells
  * 2.8 Understanding Exit Codes
  * Lesson 2 Lab: Using bash
  * Lesson 2 Lab Solution: Using bash
* Lesson 3: Shell Scripts in a DevOps Environment
* Lesson 4: Learning Linux Essentials for Shell Scripting









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
