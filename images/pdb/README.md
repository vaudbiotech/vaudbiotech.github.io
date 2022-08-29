# PDB
Protein structure illustration of 2 well know mAB, which are used as examples in production_description.

* Herceptin; trastuzuman.
* Perjeta; Pertuzumab.

## Source
6OGE
Cryo-EM structure of Her2 extracellular domain-Trastuzumab Fab-Pertuzumab Fab complex
PDB DOI: 10.2210/pdb6OGE/pdb

##still images:
display settings > turn on occlusion and off shadow
lights 3
representations > use AOshiny
output: .tga convert to jpg.

## movie
ffmpeg -version
/usr/local/Cellar/ffmpeg/4.4.1_3
Create senario in VMD
Extensions > visualisation > movie maker
rotation angle 180
trajectory step size 1
movie duration sec 10
Change format > ffmpeg
Renderer tachyon
