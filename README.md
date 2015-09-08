# Welcome

This is the official git repo for ATPMAT. ATPMAT is an open source toolbox for interfacing ATP and Matlab. A tutorial has been given in the tutorial folder of this repo. IEEE 118 bus case is given under a folder with the same name. 

## How to Clone

Go ahead and try:

```
$ git clone https://ahmadmabdullah@bitbucket.org/ahmadmabdullah/atpmat.git/wiki
```
## How to run

The user will need to import one of the structures uploaded in the Tutorial folder. Then the user will need to write the following command:

```
$ BatchProcessATP(P, 'IEEE118.atp','D:\Path\To\ATPMAT', 'C:\Path\To\Output\Folder', 'C:\Path\To\ATP\File\To\Be\Simulated', 'D:\Path\To\ATP\Executables');
```
It should be noted that: 

1. The extension .atp should exist in the file name.

2. All paths must NOT be terminated by a back slash ('\'). 

3. The drives C: or D: in the above code are  there for mere illustration purposes. Folders can be anywhere on the  user's hard drive. 



## Known Issues

As of version 1.0, ATP files have to satisfy the following for the toolbox to run properly:

1. One switch has to be in ATP file. The toolbox doesn't switch cards but rather write to them. If there are no switches in the file, you will receive either an error or simulations will be wrong

2.  One voltage probe has to exist. ATPMAT will remove the probes in the file and will write its own probes. If there are no probes in the ATP file, voltages will not be recorded in the Pl4 files and thus will not exist in .MAT files.

3. Set integration time step accordingly! The user has to select the integration time step properly. This is very important when faults are near the end of the line. If the use doesn't select them properly, he/she will get an ATP error.

4. The user will need to make sure that node names are not the same as the ones used for fault, lightning and energisation cases. When creating faults, no node can have the following names F1, F1N and F1S. When creating lightning cases, no node can have the following name: L15, L14, L13, F and F1. It should be noted that the toolbox adds M and P to the node names of the line, so no node can have such names. 

## Future Versions
Future versions will solve the above known issues. 

## Executables needed for the toolbox
The user will need the following ATP executable files: runATP.exe, runAF.exe, makeATP.exe, Pl42mat.exe

Have fun!

## Google Tracking ID
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-66353663-1', 'auto');
  ga('send', 'pageview');

</script>