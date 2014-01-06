import math, random, subprocess, decimal

def main():
  for i in range(0, 10):
    filename = "wt_smd.namd"

    fixed_file = "set_fixed_atom.tcl"
    eq_run = random.randint(1,20)

    run_to_use = "run_" + str(eq_run)

    command = "cp setup_smd.sh setup_smd_current.sh"
    subprocess.call(command, shell=True)

    command = "cp qsub_smd.sh qsub_smd_current.sh"
    subprocess.call(command, shell=True)

    command = "sed -i 's/run_unique/" + run_to_use + "/g' setup_smd_current.sh"
    subprocess.call(command, shell=True)

    command = "sed -i 's/unique_name/run_" + str(i) + "/g' qsub_smd_current.sh"
    subprocess.call(command, shell=True)

    command = "sh setup_smd_current.sh"
    subprocess.call(command, shell=True)

main()
