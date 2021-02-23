This repository is a starting point for updating the _Afghan Children Reading Illustrations_ image collection. It includes:

* a sample collection with a multilingual index
* a Perl script file that
    * converts all images to highly compressed png's
    * embeds intellectual property information in each image
    * optionally adds a prefix to each image file
* a Perl script that imports existing index entries and adds new index entries to it
* an installer setup

You should be comfortable installing software and using the Windows **CMD** command prompt.

Note: If you want to create an installer for a new image collection, see [sillsdev/image-collection-starter](https://github.com/sillsdev/image-collection-starter).

# 1) Clone this repository

Click the green **Copy** button and select **Download ZIP**. Then unzip the files that have been downloaded.

# 2) Launch CMD and set the PATH

To launch the Windows CMD prompt, press the Windows key and type `cmd`.

This folder (where this `README` and `ACR-process-images.pl` are) must be in the PATH environment variable. To quickly add the current folder to the PATH, you can type:
```
set PATH="%PATH%;C:\path\to\this\folder"
```
or navigate to the folder and type:
```
set PATH="%PATH%;."
```
(**Note:** The above commands will work only for the current session: if you close the CMD window and open a new CMD window, you will need to set the PATH again. There are many tutorials online about how to permanently set the PATH; here is a good search to use for them: https://www.google.com/search?q=set+windows+path+-java.)

# 3) Set up programs on your machine

You will need a number of helper programs: [ExifTool](#3a-exiftool), [ImageMagick](#3b-imagemagick), [PNGout](#3c-pngout), [Perl](#3d-perl), and [InnoSetup](3e-innosetup). This section describes how to install them.

## 3a. ExifTool

**ExifTool** is used to embed your intellectual property information into each image. Get it at http://www.sno.phy.queensu.ca/~phil/exiftool/ and install it. It does not have an actual installer, so here are some steps:

1. Download the "Windows executable" and unzip it into this folder, alongside the file named `process-images.pl`.
2. Rename it from `exiftool(-k).exe` to just `exiftool.exe`.

Verify that if you open a new CMD window and `cd` to this folder, this command works:
```
exiftool -ver
```
You should see something like
```
11.72
```
(**Note:** you can put the `exiftool.exe` file anywhere in your filesystem -- its location just needs to be in your PATH variable.)

## 3b. ImageMagick

**ImageMagick** can be used to convert your images to PNG. Get it at http://www.imagemagick.org/script/download.php. Get the first choice under "Windows Binary Release". Run the installer and verify that if you open a new CMD window, this command works:
```
magick --version
```
You should see something like
```
Version: ImageMagick 7.0.7-1 Q16 x64 2017-09-09 http://www.imagemagick.org
Copyright: Copyright (C) 1999-2015 ImageMagick Studio LLC
```

(**Note:** jpeg photographs or very complicated color drawings that include lots of shading are better not being automatically converted to the png format. If you have such images, it is better to experiment with different ImageMagick compression settings to find which settings give the best results in terms of size and image quality. Then you can convert your jpg files to png files before running the `process-images.pl` script (below).)

## 3c. pngout

**pngout** is used to compress PNG files. Get it here: http://advsys.net/ken/utils.htm. Like ExifTool, pngout lacks an installer. Put the file named `pngout.exe` in this folder, alongside the file named `process-images.pl` (or anywhere else on your Windows PATH). Type following command in a CMD window while cd'd into this folder:
```
pngout
```
You should see a bunch of documentation on how to use pngout, which you can ignore.

## 3d. Perl

**Perl** is used to process the images and help prepare the index file. Get it here: https://strawberryperl.com/. Be sure to get the MSI installer. Download the installer and run it. To verify that it is properly installed, type the following command in a CMD window:
```
perl -version
```
You should see a response similar to this:
```
This is perl 5, version 32, subversion 1 (v5.32.1) built for MSWin32-x64-multi-thread
```
## 3e. InnoSetup

**InnoSetup** will make your installer. Get the unicode version here: (http://www.jrsoftware.org/isdl.php).

# 4) See if you can create the Sample Collection

Before customizing anything, test out your setup by creating the sample collection. Open a **CMD** command prompt window, `cd` to this folder, and run:
```
test-process-images.pl
```
That should create a `test-output` folder containing an image of a green star a `test-processed-images` subfolder containing two images of rectangles.

Now make an installer. Double click the `test-installer.iss` file. **InnoSetup** should run. Click `Build:Compile`. That should create `/test-output/Shapes Collection 1.0.exe`. 

Next, run the `/test-output/Shapes Collection 1.0.exe` program. 

When it is done, look in `%programdata%\SIL\ImageCollections\` (which is probably `C:\ProgramData\SIL\ImageCollections` on your computer; since `C:\ProgramData\` is usually hidden, you may need to use the "Show hidden files" in Windows File Explorer to find it). You should see a folder called `Shapes`. You can also fire up Bloom and open an Image Toolbox window, and search for "star". (Make sure that there is a checkbox next to "Shapes" in the "Galleries" drop-down list.) You should see the green star. 

After you have verified that the `Shapes` folder is in the `C:\ProgramData\SIL\ImageCollections` folder, you can run the `unins000.exe` program in that folder. This will remove the `Shapes` image gallery from your computer.)

# 5) Set up your image files

Copy the images you want to add to the _ACR Illustrations_ into the `ACR-images` folder. `ACR-images` has a set of subfolders to match the ACR Illustrations categories (Actions, Animals, Food, FromBooks, Miscellaneous, Objects, People). If you want to add an image to an existing _ACR Illustrations_ sub-folder, put it in the appropriate sub-folder (for instance, _People\new-image.png_).

**IMPORTANT:** Be sure the names of your new image files are not the same as the names of any existing _ACR Illustrations_ images.

# 6) Process your images

We need an automated process that will take each image in the `images` directory, get it all ready, and put it in the `output\processed-images` directory. This is what the `process-images.pl` does. Run it by typing:
```
perl process-images.pl
```
For each image in `images`, `process-images.pl` does the following:

* makes a png and places the new image in `output\processed-images\` using ImageMagick (unless the image is a jpg file -- jpgs are not converted to png)
* compresses the png file using pngut
* pushes in metadata using ExifTool

The copyright and licensing information are hard-coded in `process-images.pl`, but you can edit them if you need to. 

# 6) Set up your index

The _index_ is how Bloom locates images that match search terms you type in the Bloom toolbox. There are two steps to getting your index ready: (a) [creating index entries for the images you are adding to _ACR Illustrations_](#6a-create-new-index-entries), and (b) [preparing the index for use](#6b-prepare-the-index-for-use).

## 6a) Create new index entries

The index is a tab-delimited, Unicode (UTF-8) text file. The first row is a heading with ISO 639 language codes. For the _ACR Illustrations_, the header row is:

    filename **(tab)** subfolder **(tab)** ps **(tab)** prs **(tab)** en

where _ps_ is Pashto and _prs_ is Dari. (But don't put spaces on either side of the tabs -- those are only there to make it more readable. Also, ACR's Bloom books in Pashto use **pbt** [Southern Pashto](#https://iso639-3.sil.org/code/pbt) as the language code for Pashto, while `index.txt` uses the generic Pashto language code **ps**. It's OK that they're different.)

Following the header row, the index needs a row for each image in the collection. Within a column of index terms for a language, terms are separated by commas. For example, this row is for a file named "image315.png". (It could end in ".tif", ".png", or any other filename extension -- the index doesn't care.) It is in a subfolder named "Actions".
```
image315.png (tab) Actions (tab) زده کونکی,پشی,تلل,عملونه (tab) شاگردان,پشک,رفتن,اعمال (tab) students,cat,go,actions
```
(Again, don't put spaces on either side of the tab characters.)

Here are some things to be careful about:

* An easy mistake to make when creating index.txt is to lose the Unicode (UTF-8) formatting. For example, you might create the index in a spreadsheet program, then export as "tab delimited text". If you do this, make sure you to create a Unicode (UTF-8) document, otherwise any non-Western character will be changed to a question mark.  

  In Microsoft Excel, use Save as... > and choose **Unicode text (*.txt)** as the file format. Doing this may introduce unwanted quotation marks around each set of tags, however.  

  The safest way to move your index data from a spreadsheet program is to copy and paste it into a text editor such as Notepad or Visual Code. This lets you more easily control the file encoding.
* Be sure that any commas that separate search terms are Western commas (**,**, U+002C), not Arabic commas (**،**, U+060C). If you have Arabic commas in your search terms, Bloom will not recognize them as separate search terms.
* Be sure that no file is listed twice -- this will cause an error in Bloom. One way to check for duplicates is to turn on "conditional formatting" in your spreadsheet program, with the condition "duplicate".
* It is good practice to put the name of the subfolder at the end of the search strings (in the above example, Pashto عملونه, Dari اعمال, English _actions_).

## 6b) Prepare the index for use

Run the following command:
```
perl clean-index.pl
```
This script fetches the index from the _Afghan Children Reading Illustrations_ collection that is already installed on the computer and adds the contents of your new `index.txt` to it. If the _ACR Illustrations_ collection is not installed (to be specific, if it is not installed in `C:\ProgramData\SIL\ImageCollections\Afghan Children Read`), the script will give an error message and stop.

# 7) Make the installer

Double click the `ACR-installer.iss` file. **Innosetup** should open.

You can change the AppVersion to reflect updates to _ACR Illustrations_. Do not edit any of the other values. 

**IMPORTANT:** Do not change the AppId GUID. If you do, you will create a second _ACR Illustrations_ collection on the user's computer.

Click **Build:Compile**. That should create `/ACR-output/Install ACR Illustrations.exe`.

# 8) Run the installer

Double click the `Install ACR Illustrations.exe` file to install the new illustrations. When it is done, look in `%programdta%\SIL\ImageCollections\`. You should see your collection. Finally, run Bloom and search for one of your images.

# Background information: File locations

It is helpful to know about how and where Bloom searches for images. Bloom image collections are stored in the following location in your computer’s file system:
```
    C:\ProgramFiles\SIL\ImageCollections
```
The _Afghan Children Reading Illustrations_ collection is stored in this folder:
```
    C:\ProgramFiles\SIL\ImageCollections\Afghan Children Read
```
Inside, there are two items you need to know about: the `index.txt` file and the `images` folder.

* `index.txt` stores the tags or search terms that you can use to search for an image.
* `images` folder stores all the images in the image collection.

# If you need help...

Contact [SIL LEAD](https://www.sil-lead.org). 
