# File-Integrity-Monitor
<h2>Aim: </h2>
<p>The objective is to understand the practical implication of the one of the important factors in the CIA triad - Integrity. In this project, we demonstrate how integrity of a file changes when modifications are done on the file or on the directory.

This is done by using a PowerShell script, coded in such a way, so as to monitor any changes done to a set of files. I have explained how the process works in-depth below. Feel free to learn!</p>

<h2>Tools required: </h2>

- <b>PowerShell ISE (with administrator access)</b>
- <b>A folder with files for demonstration</b>

<h2>Working:</h2>

<h3>Scripting: </h3>

<p>For this project, we need to have prepare a target folder with files. Integrity of these created files will be monitored. Create a folder in an easy accessible directory. I've named it as "FIM". This is where all the content required/created would be stored. Create another folder within the "FIM" directory. I've named it as "Files".

Now, within "Files", create few .txt files. Content in the files does not matter, however the hash generated would be based on the content, hence it is important to remember the data for the sake of this proect. To make things simple, I've created 4 .txt files named a,b,c & d respectively. Store something simple in the files. Here, I have stored "aaa" for a.txt and so on for the other files as well.</p><br>
<p align="center">
<img src="https://i.imgur.com/FfDQElc.jpeg" height="80%" width="80%"><br>
Fig 1.1<br></p>
<p align="center">
<img src="https://i.imgur.com/K1RfW1i.jpg" height="80%" width="80%"><br>
Fig 1.2<br></p>
<p>It is time for scripting! Go ahead and open PowerShell ISE and run it in administrator mode.</p>

<h4>Functions used: </h4>

- <b>CalculateHash</b> : This function creates a SHA-512 hash for the file mentioned in the "$filepath" and stores the hash in the variable "$filehash".
- <b>EraseBaseline</b> : This function is created to check whether a baseline already exists in the folder. The purpose of checking baseline will be explained later below. The method "Test-Path" checks whether a particular file exists in the current directory. If it does, a boolean value is returned. In line 11 from fig 1.3, if the returned value is true, then you remove the baseline.txt file.<br>
<p align="center">
<img src="https://i.imgur.com/SnRrZLw.jpg" height="80%" width="80%"><br>
Fig 1.3<br></p>

<h4>Main :</h4>
<p>This is divided into 4 parts: </p>

- <b>Prompts for the user</b>
- <b>if condion</b>
- <b>elseif condition</b>
- <b>else condition</b>
<br>
<p align="center">
<img src="https://i.imgur.com/zBK33zq.jpg" height="80%" width="80%"><br>
Fig 1.4<br></p>
<b>Prompts: </b><br>
<p> The user is given two options -  to either create a new baseline or to start monitoring with the saved baseline. The response is stored in "$response". If "A" is chosen, then if the if condition is triggered. If "B" is chosen, then elseif is executed.</p><br>
<b>If condition: </b><br>
<p>This condition creates a baseline.txt in the "FIM" folder. A baseline is essentially an initial storage of the hashes of all the target files. This is later used to compare with when any changes are made to the files.

EraseBaseline function is used in line 27 because we do not need another baseline to exist when we are creating a new one in this section. 
The method "-Get-ChildItem" in line 29 stores the file names in the variable "$files" from the path mentioned i.e ".\Files".

The foreach loop in line 30 iterates throuh all the files and stores it's hash in the varaible "$hash" using the userdefined function CalculateHash. Line 33 is how we decide the way the outut is stored in the baseline.txt file - filename|hash. For example, a.txt|123455. -Append is used so that the outputs dont override the previous output.
</p><br>
<p align="center">
<img src="https://i.imgur.com/EFmWczq.jpg" height="80%" width="80%"><br>
Fig 1.5<br></p>
<b>elseif condition: </b><br>
<p>This condtion uses the existing baseline to monitor any modifications done on the target files. We use a dictionary to do the comparison ie "$filehashDictiontary". The variable "$filePathsandHashes" stores all the content of the already existing baseline.txt.

The foreach loop in line 41 stores the content of baseline stored in the $filePathandHashes to the created dictionary. But we know that dictionary only stores values in the form on (key, value). So, we split the baseline data into key and value pairs, wherein the key is the path and the value is the corresponding hash of that file. Remember, in baseline, the information is stores as path|hash.

We use inbuilt Split funtion to seperate the key and value. "$i.Split("|")[0],$i.Split("|")[1]" means that the loop ges through each character in the $filePathsandHashes and searches for the "|" character. When it is found, any content preceeding the character is marked as index 0, and the the remaining as index 1. Hence we have successfully split the content in baseline and stored it in the dictionary in the appropriate key,value format.</p><br>
<p align="center">
<img src="https://i.imgur.com/qivACf3.jpg" height="80%" width="80%"><br>
Fig 1.6<br></p>
<p>In Line 51, we store the hash values of the files in the $hash, similar to how we did it earlier in the if condition. Then, the if condition in line 52 checks whether a new file is created.  If a file is found in the current scan ($hash.Path) that is not present in the baseline ($filehashDictionary), it is considered as a new file, and a corresponding message is printed to the console.

Line 58 compares the stored hash in the $fileHashDictionary (the hash from the baseline) associated with the file path $hash.Path against the current hash $hash.Hash calculated for the same file. If the hashes are equal, it means that the file has not changed since the last baseline, and the code enters the inner block with the comment # The file has not changed. else: If the hashes are not equal, it means that the file has changed, and the code enters the else block. In this case, it prints a message to the console indicating that the file has changed. 

foreach loop in line 68 checks whether a file has been deleted or not. First it checks whether all the keys (files) exists in the dictionary. If any one of them does not exist, then a message claiming that that particular file has been deleted is printed on the console.</p><br>

<b>else conditon: </b><br>
<p>This just checks whether the user has entered any other option other than "A" or "B". If so, then a message requests them to input the given options only.</p><br>
<p align="center">
<img src="https://i.imgur.com/jxdNI8r.jpg" height="80%" width="80%"><br>
Fig 1.7<br></p>

<h2>Ouputs and Test cases: </h2>
<h3>Output:</h3>
<p>Ensure that in the PowerShell console, the program is executed in the "FIM" directory. Use "cd <path>" to redirect.

First let us run the program and choose option A to create a baseline.</p>
<p align="center">
<img src="https://i.imgur.com/tJ2DweC.jpg" height="80%" width="80%"><br>
Fig 2.1<br></p>
<p>A baseline.txt file has been created which stores path|hash. Now we run the program again and choose B.</p><br>
<p align="center">
<img src="https://i.imgur.com/q9gQUNP.jpg" height="80%" width="80%"><br>
Fig 2.2<br></p>
<p>The while loop in line 45 from fig 1.6 would keep the program in an infinite monitoring mode. It will display outputs only if the file status is updated. Let us test them out.</p><br>

<h3>Test cases:</h3>
<b>Test case 1:</b><br>
<p>We create a new file in the "Files" folder. The program will then check the path of the new file and compare with the dictionary. When it realises that the new path is not stored as a key in the dictionary, it prints outputs. These outputs will be displayed every second until and unless the file has been deleted to restore the baseline state.</p><br>
<p align="center">
<img src="https://i.imgur.com/gSFRfyx.jpg" height="80%" width="80%"><br>
Fig 2.3<br></p>
<p align="center">
<img src="https://i.imgur.com/Eg9zqtl.jpg" height="80%" width="80%"><br>
Fig 2.4<br></p>
<b>Test case 2:</b><br>
<p>We change the content of the already existing files. This will lead to a change in hash value. This new hash value is compared with the already existing hash value of that file in the dictionary. If the values are not equal, then outputs are produced. These outputs will be displayed until the changes are undone.</p><br>
<p align="center">
<img src="https://i.imgur.com/GKch7SQ.jpg" height="80%" width="80%"><br>
Fig 2.5<br></p>
<p align="center">
<img src="https://i.imgur.com/wu1anPe.jpg" height="80%" width="80%"><br>
Fig 2.6<br></p>
<b>Test case 3:</b><br>
<p>We delete a file. The foreach loop in line 68 from fig 1.6 continous checks the status of the keys in the dictionary. If a file is deleted, the if condition in the loop is triggered and outputs are produced. These outputs will be displayed until the deleted file and its content is restored.</p><br>
<p align="center">
<img src="https://i.imgur.com/62RyAZI.jpg" height="80%" width="80%"><br>
Fig 2.7<br></p>
<p align="center">
<img src="https://i.imgur.com/a9Krraz.jpg" height="80%" width="80%"><br>
Fig 2.8<br></p>
<p>Notice that when we try to restore the deleted d.txt file, we receive all the testcase outputs. This is great, because we know that monitor is doing its job correctly. </p><br>
<p align="center">
<img src="https://i.imgur.com/JZlrw8F.jpg" height="80%" width="80%"><br>
Fig 2.9<br></p>

<h2>Takeaways: </h2>

- <b>Understanding of PowerShell Scripting: </b><p>Gain proficiency in using PowerShell for system administration tasks. Learn how to leverage PowerShell cmdlets and functions for file manipulation and system monitoring.</p>
- <b>File Integrity Monitoring</b>: <p>Understand the concept of file integrity monitoring (FIM) and its importance in detecting unauthorized changes to files.</p>
- <b>Hashing Algorithms</b>: <p>Explore the use of hashing algorithms, such as SHA-512, for generating unique identifiers (hashes) for files.</p>
- <b>User Interaction and Input Handling</b>: <p>Handle user input validation to ensure the correct options are selected.</p>
- <b>Error Handling</b>: <p>Implement error handling mechanisms to gracefully handle situations such as file deletion or incorrect user input.</p>
- <b>Real-time Monitoring:</b>: <p>Develop a real-time monitoring loop using PowerShell to continuously check for changes in specified files and report those changes.</p>
