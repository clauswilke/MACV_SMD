import sys, os, math, string, re, gzip, urllib, shutil, fnmatch
import cStringIO
from prody import *
import numpy as np
from numpy import arange, cos, linspace, pi, sin, random

def main():
 
  forces    = parse_log()
  distances = parse_dcd()
   
## Strips whitespace from list elements
def striplist(l):
  return([x.strip() for x in l])

## Python shenanigans to remove empty elements in a list
## This function strips whitespace as well 
def stripempties(l):
  return([x.strip() for x in l if x != ''])
            
def parse_dcd():

  pdb_file = ""
  dcd_file = ""
  log_file = ""
        
  ## Find input file names by pattern matching
  for file in os.listdir('.'):
    if fnmatch.fnmatch(file, '*ionized.coor'):
    ##    print file
        pdb_file = file
    if fnmatch.fnmatch(file, '*pulled*.dcd'):
    ##    print file
        dcd_file = file
    if fnmatch.fnmatch(file, '*smd*.log'):
    ##    print file
        log_file = file

  structure = parsePDB( pdb_file )
  traj      = Trajectory( dcd_file )
  traj.setAtoms( structure )
  
  file_out  = "distances.dat"

  tfr1 = structure.select('calpha and resnum 1 to 162')

  macv = structure.select('calpha and resnum 163 to 318')
 
  distances = np.zeros( traj.numFrames() )
  
  output_handle = open(file_out, 'w')

  start_dist = 0

  did_they_sep = False
  sep_time = 0

  for i, frame in enumerate(traj):
    center_tfr1 = calcCenter(tfr1)
    center_macv = calcCenter(macv)
    
    if( i == 0 ):
      dist_3d = center_tfr1 - center_macv
      start_dist = np.sqrt( dist_3d[0]**2 + dist_3d[1]**2 + dist_3d[2]**2 )

    distance_3d = center_tfr1 - center_macv
     
    this_distance = np.sqrt( distance_3d[0]**2 + distance_3d[1]**2 + distance_3d[2]**2 )
    
    distances[i] = this_distance - start_dist
    out_line = "%s %s\n" % ( i, distances[i] )
    output_handle.write( out_line )

    ## Test if the average seperation of the last 10 steps is greater than 5 A
    ## This is to eliminate some noise in barrier crossing
    ## parse_settings will return the frame retention rate so time
    ## will be in the same units across the simulations

    if( np.mean(distances[i-10:i]) > 5 and not did_they_sep ):
      did_they_sep = True
      sep_time = float(i * parse_settings()) * 2
      
    else:
      sep_time = float(i * parse_settings()) * 2 

  force = parse_config() * len(macv)
  
  print( '%s %f %f\n' % (did_they_sep, sep_time, force) )
  output_handle.close()
  
  return 0
  
def parse_settings():
  namd_file = ""
  for file in os.listdir('.'):
    if fnmatch.fnmatch(file, '*smd*.namd'):
      namd_file = file

  in_handle = open(namd_file, 'r')
  
  dcd_freq = re.compile("dcdfreq")
  
  ## Search for the dcdfreq line and return its value multiplied by step size
  ## step size is almost always 2 fs for our simulations

  for line in in_handle.readlines():
    if re.search(dcd_freq, line):
      split_dcd_freq = line.split(' ')
      split_dcd_freq = stripempties(split_dcd_freq)

      ## returns the step size between frames in picoseconds
      return(float(split_dcd_freq[1]) * 2.0 / 1000)

def parse_config():
  fixed_file = ''
  for file in os.listdir('.'):
    if fnmatch.fnmatch(file, '*fixed_atom.tcl'):
      fixed_file = file

  in_handle = open(fixed_file, 'r')

  force_line = re.compile('smdatom set occupancy')
  
  for line in in_handle.readlines():
    if re.search(force_line, line):
      split_force_line = stripempties(line.split(' '))
      return(float(split_force_line[3]))

## Main function call  
if __name__ == "__main__":
  main()
