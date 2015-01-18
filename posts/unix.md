UNIX
====

Two approaches to langauge design:

+ Programming is a mathematical exercise: seek the core essence of computation. E.g. Haskell.
+ Programming is an engineering exercise: if its stupid, and it works, it ain't stupid. E.g. Unix


Not so much a langauge for a programmer as a system for many
programmers to work together

+  Bell Labs, 1970s. The great divided house.
+ So many CS Ph.D.s just walking the halls.
+ UNIX, Bash, C, make, man pages, so many innovations that we still use today
    + No Bell Labs, no UNIX, no LINUX, no open source

Philosophy
----------

+ Write programs that do one thing and do it well. 
    + UNIX has hundreds of domain specific-languages, each doing one little task.
	+ e.g. ls, cp, rm, and (see below) bash, make.
+ Write programs to work together. 
+ Write programs to handle text streams, because that is a universal interface.
+ Small is beautiful.
+ Build a prototype as soon as possible.
+ Choose portability over efficiency.
+ Use shell scripts to increase leverage and portability.
+ Avoid captive user interfaces.
+ Make every program a filter.

Quotes:

+ "Unix was not designed to stop its users from doing stupid things, as that would also stop them from doing clever things." - Doug Gwyn
+ "Unix never says 'please'." - Rob Pike
+ "Worse is better" (Richard P. Gabriel)
     +  Simplicity of both the interface and the implementation are more important than any other attributes of the system—including correctness, consistency, and completeness. 
     + Has key evolutionary advantages
     + E.g. 
	       + GNU never produced a UNIX distro.
           + Though Lisp compilers in 1987 were about as good as C compilers, there are many more compiler experts who want to make C compilers better than want to make Lisp compilers better.
		   
Conventions
-----------

Your code has the same status as the operating's systems code

+ Commands are searched along a path
+ If you add _$HOME/bin_ to the front of the path
       Then UNIX will run your commands before anyone else's.

### File structure conventions

+ [Standardized](http://en.wikipedia.org/wiki/Unix_directory_structure)

### Convention for interfacing programs:

+ Everything is text. No special binary filters.
+ Everything has man pages [ls])http://unixhelp.ed.ac.uk/CGI/man-cgi?ls)
     + So _programming_ has documentation standards.
+ Comamnds have flags, e.g. ls -lsat
     + -l = long listing
     + -s = show size
     + -t = show in reverse order of access
     + -a = show all details. 
     + See also -h : help text
         + So to work out a command, type _com -h_
+ Pipes
    + Sequence of filters with buffers in-between them.
	+ Linear, not Y-shaped (worse is better)

![http://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Pipeline.svg/570px-Pipeline.svg.png](http://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Pipeline.svg/570px-Pipeline.svg.png)

### The famous Mcllroy pipeline
          
Read a file of text, determine the n most frequently used words, and print out a sorted list of those words along with their frequencies.

    
    tr -cs A-Za-z '\n' |
    tr A-Z a-z |
    sort |
    uniq -c |
    sort -rn |
    sed ${1}q


BTW, the same thing in HASKELL:


    import qualified System
    import qualified Data.List as List
    import qualified Data.Char as Char
    import qualified Data.HashMap.Strict as HashMap
     
    main :: IO ()
    main = do
         [arg] <- System.getArgs
         text <- getContents
         let n = read arg
         putStr $ createReport n text
     
    createReport :: Int -> String -> String
    createReport n text =
         unlines $
         map (\(w, count) -> show count ++ " " ++ w) $
         take n $
         List.sortBy (flip compare) $
         map (\(w, count) -> (count, w)) $
         HashMap.toList $
         HashMap.fromListWith (+) $
         map (\w -> (w, 1)) $
         words $
         map Char.toLower $
         map (\c -> if Char.isLetter c then c else '\n') $
         text


(Probably faster in HASKELL.)

Bash
----

A domain-specific language for pushing around files.

A language where arithmetic is hard and file maniupulation is easy.

A data mining experiment, written in Bash script:

         1	Gawk=gawk
         2	
         3	#### experiment control #######################
         4	
         5	Repeats=5
         6	Bins=5
         7	Learners="nb j48"
         8	
         9	#### learners, treatments, etc ################
        10	
        11	j48() {
        12	    $Weka weka.classifiers.trees.J48  -C 0.25 -M 2 -p 0 -t $1 -T $2
        13	}
        14	
        15	nb() {
        16	    $Weka weka.classifiers.bayes.NaiveBayes -p 0 -t $1 -T $2 
        17	}
        ...
        24	run() {
        25	    for Datum in $Datasets;do
        26	      for DatumN in `ls $Data/${Datum}_fs*`; do
        27	         for((r=1;r<=Repeats;r++)); do
        28	            for((Bin=1;Bin<=$Bins;Bin++)); do
        29	              somearff Bins=$Bins Bin=$Bin Seed=$RANDOM $DatumN
        30	              blab "#-- `basename $DatumN` $r $Bin $Learner"
        31	              for Learner in $Learners; do
        32	                blab "#-- `basename $DatumN` $r $Bin $Learner"
        33	                $Learner train.arff test.arff  | actpred | 
        34	                abcd Db=`basename $DatumN` Rx="$Learner"  | malign
        35	              done  
        36	            done
        37	         done
        38	      done 
        39	    done 
        40	}


Notes:

+ Text substitution lanaugage: $X means use the value of X. See line 1
+ Code as data: see _$Learner_ line 33
+ Chewing gum to tie together different tools: see line 26.
+ Sub-rotuines with numerbered arguments, see lines 14 to 17 $1, $2.


UNIX LIVES
==========

Most of the original authors of UNIX now work at Google on
the GO language (son of son of son of _C_).

What makes large-scale development hard with C++ or Java (at least):

+ slow builds
+ uncontrolled dependencies
+ each programmer using a different subset of the language
+ poor program understanding (documentation, etc.)
+ duplication of effort
+ cost of updates
+  version skew
+ difficulty of automation (auto rewriters etc.): tooling
+ cross-language builds

Language features don't usually address these. Need
better language, system interfaces. Enter
[Go](http://talks.golang.org/2012/splash.article).

<center>
<iframe width="560" height="315" 
src="http://www.youtube.com/embed/wwoWei-GAPo" 
frameborder="0" allowfullscreen></iframe>
</center>






