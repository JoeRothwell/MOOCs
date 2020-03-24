# Process text output from stata: total of 16 digestive cancers

# Get number of failures per cancer
egrep "ent:|failures in" LOG_digestive_cancers_27mods.txt > failures_16cancers.txt

# Extract all HRs and CIs from text output and write to file or get number of lines
egrep "event|Idiabet_1|_Ipre_diabe_1|harm_1|_NCEP_1|metS_IDF2_1|obes_1|hdl_1|health_1|health_2|health_3|tryg_1|bp_1|hb_1" LOG_digestive_cancers_27mods.txt > digestive_cancers_metS.txt
egrep "event|Idiabet_1|_Ipre_diabe_1|harm_1|_NCEP_1|metS_IDF2_1|obes_1|hdl_1|health_1|health_2|health_3|tryg_1|bp_1|hb_1" LOG_digestive_cancers_27mods.txt | wc -l
# 512
# shortened with metacharacters
egrep "ent:|diabet?_1|arm_1|CEP_1|IDF2_1|obes_1|hdl_1|hb_1|bp_1|tryg_1|alth_[123]" LOG_digestive_cancers_27mods.txt | wc -l

# Extra corrected file
egrep "event|Idiabet_1|health_1|health_2|health_3" LOG_digestive_cancers_corrections.txt > digestive_cancers_metS_extra.txt
egrep "event|alth_[123]" LOG_digestive_cancers_corrections.txt
