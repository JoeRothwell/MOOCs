# Process text output from stata

# Extract all HRs and CIs from text output
egrep "event|Idiabet_1|_Ipre_diabe_1|harm_1|_NCEP_1|metS_IDF2_1|obes_1|hdl_1|health_1|health_2|health_3|tryg_1|bp_1|hb_1" LOG_digestive_cancers_27mods.txt > digestive_cancers_metS.txt

# Number of lines
egrep "event|Idiabet_1|_Ipre_diabe_1|harm_1|_NCEP_1|metS_IDF2_1|obes_1|hdl_1|health_1|health_2|health_3|tryg_1|bp_1|hb_1" LOG_digestive_cancers_27mods.txt | wc -l
# 512

# Extra corrected file
egrep "event|Idiabet_1|health_1|health_2|health_3" LOG_digestive_cancers_corrections.txt > digestive_cancers_metS_extra.txt
