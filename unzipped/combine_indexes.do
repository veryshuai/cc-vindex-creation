* This stata script combines the vindexes for the different demographics

*Merge all relevant files

cd /home/veryshuai/Documents/cc/downloads/unzipped/vindex_for_paper
global tables_version "20140322"

* This loop sorts, and creates a merge id
foreach agegroup in "be40" "up40"{
    foreach reggroup in "northeast" "south" "midwest" "west"{
        use Vindices${tables_version}`agegroup'`reggroup', clear // use the heffetz output
        * Capture prevents a stop when merge id doesn't exist
        capture{
        drop merge_id // if you have run the script before, these will be around
        }
        g merge_id = ncats3`agegroup'`reggroup' // merge on the three letter good category
        sort merge_id // need to sort the merge id to merge
        save Vindices${tables_version}`agegroup'`reggroup'_mergeready, replace
        }
    }

* Merge
clear
g merge_id = "null" // need to have merge id in memory to start
sort merge_id  // needs to be sorted :P
foreach agegroup in "be40" "up40"{
    foreach reggroup in "northeast" "south" "midwest" "west"{
        merge merge_id using Vindices${tables_version}`agegroup'`reggroup'_mergeready
        sort merge_id // resort
        drop _merge // drop the merge output (can also rename if you want it)
        }
    }

* Remove extraneous variables
keep merge_id catsb*

save merged_vin_data, replace


