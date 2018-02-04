

#---------------------------------
# New invocation of recon-all Thu Feb  1 01:38:58 UTC 2018 

 mri_convert /home/ubuntu/sMRI/3220.nii /usr/local/freesurfer/subjects/3220/mri/orig/001.mgz 

#--------------------------------------------
#@# MotionCor Thu Feb  1 01:39:14 UTC 2018

 cp /usr/local/freesurfer/subjects/3220/mri/orig/001.mgz /usr/local/freesurfer/subjects/3220/mri/rawavg.mgz 


 mri_convert /usr/local/freesurfer/subjects/3220/mri/rawavg.mgz /usr/local/freesurfer/subjects/3220/mri/orig.mgz --conform 


 mri_add_xform_to_header -c /usr/local/freesurfer/subjects/3220/mri/transforms/talairach.xfm /usr/local/freesurfer/subjects/3220/mri/orig.mgz /usr/local/freesurfer/subjects/3220/mri/orig.mgz 

#--------------------------------------------
#@# Talairach Thu Feb  1 01:39:55 UTC 2018

 mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 


 talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm 

talairach_avi log file is transforms/talairach_avi.log...

 cp transforms/talairach.auto.xfm transforms/talairach.xfm 

#--------------------------------------------
#@# Talairach Failure Detection Thu Feb  1 01:44:17 UTC 2018

 talairach_afd -T 0.005 -xfm transforms/talairach.xfm 


 awk -f /usr/local/freesurfer/bin/extract_talairach_avi_QA.awk /usr/local/freesurfer/subjects/3220/mri/transforms/talairach_avi.log 


 tal_QC_AZS /usr/local/freesurfer/subjects/3220/mri/transforms/talairach_avi.log 

#--------------------------------------------
#@# Nu Intensity Correction Thu Feb  1 01:44:18 UTC 2018

 mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 


 mri_add_xform_to_header -c /usr/local/freesurfer/subjects/3220/mri/transforms/talairach.xfm nu.mgz nu.mgz 

#--------------------------------------------
#@# Intensity Normalization Thu Feb  1 01:50:09 UTC 2018

 mri_normalize -g 1 -mprage nu.mgz T1.mgz 

#--------------------------------------------
#@# Skull Stripping Thu Feb  1 01:56:17 UTC 2018

 mri_em_register -rusage /usr/local/freesurfer/subjects/3220/touch/rusage.mri_em_register.skull.dat -skull nu.mgz /usr/local/freesurfer/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta 


 mri_watershed -rusage /usr/local/freesurfer/subjects/3220/touch/rusage.mri_watershed.dat -T1 -brain_atlas /usr/local/freesurfer/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz 


 cp brainmask.auto.mgz brainmask.mgz 

#-------------------------------------
#@# EM Registration Thu Feb  1 03:13:25 UTC 2018

 mri_em_register -rusage /usr/local/freesurfer/subjects/3220/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /usr/local/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta 

#--------------------------------------
#@# CA Normalize Thu Feb  1 03:56:58 UTC 2018

 mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /usr/local/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz 

#--------------------------------------
#@# CA Reg Thu Feb  1 04:01:01 UTC 2018

 mri_ca_register -rusage /usr/local/freesurfer/subjects/3220/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /usr/local/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z 

#--------------------------------------
#@# SubCort Seg Thu Feb  1 10:37:05 UTC 2018

 mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /usr/local/freesurfer/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz 


 mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /usr/local/freesurfer/subjects/3220/mri/transforms/cc_up.lta 3220 

#--------------------------------------
#@# Merge ASeg Thu Feb  1 14:18:43 UTC 2018

 cp aseg.auto.mgz aseg.presurf.mgz 

#--------------------------------------------
#@# Intensity Normalization2 Thu Feb  1 14:18:43 UTC 2018

 mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS Thu Feb  1 14:27:26 UTC 2018

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation Thu Feb  1 14:27:30 UTC 2018

 mri_segment -mprage brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz 


 mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz 

#--------------------------------------------
#@# Fill Thu Feb  1 14:34:55 UTC 2018

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz 

#--------------------------------------------
#@# Tessellate lh Thu Feb  1 14:37:02 UTC 2018

 mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz 


 mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix 


 rm -f ../mri/filled-pretess255.mgz 


 mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix 

#--------------------------------------------
#@# Tessellate rh Thu Feb  1 14:37:19 UTC 2018

 mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz 


 mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix 


 rm -f ../mri/filled-pretess127.mgz 


 mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix 

#--------------------------------------------
#@# Smooth1 lh Thu Feb  1 14:37:37 UTC 2018

 mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix 

#--------------------------------------------
#@# Smooth1 rh Thu Feb  1 14:37:51 UTC 2018

 mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix 

#--------------------------------------------
#@# Inflation1 lh Thu Feb  1 14:38:05 UTC 2018

 mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix 

#--------------------------------------------
#@# Inflation1 rh Thu Feb  1 14:39:26 UTC 2018

 mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix 

#--------------------------------------------
#@# QSphere lh Thu Feb  1 14:40:55 UTC 2018

 mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix 

#--------------------------------------------
#@# QSphere rh Thu Feb  1 14:49:28 UTC 2018

 mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix 

#--------------------------------------------
#@# Fix Topology Copy lh Thu Feb  1 15:00:08 UTC 2018

 cp ../surf/lh.orig.nofix ../surf/lh.orig 


 cp ../surf/lh.inflated.nofix ../surf/lh.inflated 

#--------------------------------------------
#@# Fix Topology Copy rh Thu Feb  1 15:00:08 UTC 2018

 cp ../surf/rh.orig.nofix ../surf/rh.orig 


 cp ../surf/rh.inflated.nofix ../surf/rh.inflated 

#@# Fix Topology lh Thu Feb  1 15:00:08 UTC 2018

 mris_fix_topology -rusage /usr/local/freesurfer/subjects/3220/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 3220 lh 

#@# Fix Topology rh Thu Feb  1 17:28:01 UTC 2018

 mris_fix_topology -rusage /usr/local/freesurfer/subjects/3220/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 3220 rh 


 mris_euler_number ../surf/lh.orig 


 mris_euler_number ../surf/rh.orig 


 mris_remove_intersection ../surf/lh.orig ../surf/lh.orig 


 rm ../surf/lh.inflated 


 mris_remove_intersection ../surf/rh.orig ../surf/rh.orig 


 rm ../surf/rh.inflated 

#--------------------------------------------
#@# Make White Surf lh Thu Feb  1 19:27:41 UTC 2018

 mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs 3220 lh 

#--------------------------------------------
#@# Make White Surf rh Thu Feb  1 19:39:06 UTC 2018

 mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs 3220 rh 

#--------------------------------------------
#@# Smooth2 lh Thu Feb  1 19:50:06 UTC 2018

 mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm 

#--------------------------------------------
#@# Smooth2 rh Thu Feb  1 19:50:21 UTC 2018

 mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm 

#--------------------------------------------
#@# Inflation2 lh Thu Feb  1 19:50:33 UTC 2018

 mris_inflate -rusage /usr/local/freesurfer/subjects/3220/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated 

#--------------------------------------------
#@# Inflation2 rh Thu Feb  1 19:52:01 UTC 2018

 mris_inflate -rusage /usr/local/freesurfer/subjects/3220/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated 

#--------------------------------------------
#@# Curv .H and .K lh Thu Feb  1 19:53:25 UTC 2018

 mris_curvature -w lh.white.preaparc 


 mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated 

#--------------------------------------------
#@# Curv .H and .K rh Thu Feb  1 19:56:44 UTC 2018

 mris_curvature -w rh.white.preaparc 


 mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated 


#-----------------------------------------
#@# Curvature Stats lh Thu Feb  1 20:00:13 UTC 2018

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm 3220 lh curv sulc 


#-----------------------------------------
#@# Curvature Stats rh Thu Feb  1 20:00:23 UTC 2018

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm 3220 rh curv sulc 

#--------------------------------------------
#@# Sphere lh Thu Feb  1 20:00:33 UTC 2018

 mris_sphere -rusage /usr/local/freesurfer/subjects/3220/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere 

#--------------------------------------------
#@# Sphere rh Thu Feb  1 22:14:27 UTC 2018

 mris_sphere -rusage /usr/local/freesurfer/subjects/3220/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere 

#--------------------------------------------
#@# Surf Reg lh Fri Feb  2 00:14:34 UTC 2018

 mris_register -curv -rusage /usr/local/freesurfer/subjects/3220/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /usr/local/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg 

#--------------------------------------------
#@# Surf Reg rh Fri Feb  2 02:27:46 UTC 2018

 mris_register -curv -rusage /usr/local/freesurfer/subjects/3220/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /usr/local/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg 

#--------------------------------------------
#@# Jacobian white lh Fri Feb  2 04:38:28 UTC 2018

 mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white 

#--------------------------------------------
#@# Jacobian white rh Fri Feb  2 04:38:32 UTC 2018

 mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white 

#--------------------------------------------
#@# AvgCurv lh Fri Feb  2 04:38:36 UTC 2018

 mrisp_paint -a 5 /usr/local/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv 

#--------------------------------------------
#@# AvgCurv rh Fri Feb  2 04:38:39 UTC 2018

 mrisp_paint -a 5 /usr/local/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv 

#-----------------------------------------
#@# Cortical Parc lh Fri Feb  2 04:38:43 UTC 2018

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 3220 lh ../surf/lh.sphere.reg /usr/local/freesurfer/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot 

#-----------------------------------------
#@# Cortical Parc rh Fri Feb  2 04:39:15 UTC 2018

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 3220 rh ../surf/rh.sphere.reg /usr/local/freesurfer/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot 

#--------------------------------------------
#@# Make Pial Surf lh Fri Feb  2 04:39:51 UTC 2018

 mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs 3220 lh 

#--------------------------------------------
#@# Make Pial Surf rh Fri Feb  2 05:14:58 UTC 2018

 mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs 3220 rh 

#--------------------------------------------
#@# Surf Volume lh Fri Feb  2 05:50:07 UTC 2018
#--------------------------------------------
#@# Surf Volume rh Fri Feb  2 05:50:15 UTC 2018
#--------------------------------------------
#@# Cortical ribbon mask Fri Feb  2 05:50:23 UTC 2018

 mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon 3220 

#-----------------------------------------
#@# Parcellation Stats lh Fri Feb  2 06:17:42 UTC 2018

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab 3220 lh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab 3220 lh pial 

#-----------------------------------------
#@# Parcellation Stats rh Fri Feb  2 06:20:53 UTC 2018

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab 3220 rh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab 3220 rh pial 

#-----------------------------------------
#@# Cortical Parc 2 lh Fri Feb  2 06:24:18 UTC 2018

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 3220 lh ../surf/lh.sphere.reg /usr/local/freesurfer/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot 

#-----------------------------------------
#@# Cortical Parc 2 rh Fri Feb  2 06:24:59 UTC 2018

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 3220 rh ../surf/rh.sphere.reg /usr/local/freesurfer/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot 

#-----------------------------------------
#@# Parcellation Stats 2 lh Fri Feb  2 06:25:45 UTC 2018

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab 3220 lh white 

#-----------------------------------------
#@# Parcellation Stats 2 rh Fri Feb  2 06:27:21 UTC 2018

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab 3220 rh white 

#-----------------------------------------
#@# Cortical Parc 3 lh Fri Feb  2 06:28:58 UTC 2018

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 3220 lh ../surf/lh.sphere.reg /usr/local/freesurfer/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# Cortical Parc 3 rh Fri Feb  2 06:29:33 UTC 2018

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 3220 rh ../surf/rh.sphere.reg /usr/local/freesurfer/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# Parcellation Stats 3 lh Fri Feb  2 06:30:06 UTC 2018

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab 3220 lh white 

#-----------------------------------------
#@# Parcellation Stats 3 rh Fri Feb  2 06:31:42 UTC 2018

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab 3220 rh white 

#-----------------------------------------
#@# WM/GM Contrast lh Fri Feb  2 06:33:13 UTC 2018

 pctsurfcon --s 3220 --lh-only 

#-----------------------------------------
#@# WM/GM Contrast rh Fri Feb  2 06:33:32 UTC 2018

 pctsurfcon --s 3220 --rh-only 

#-----------------------------------------
#@# Relabel Hypointensities Fri Feb  2 06:33:50 UTC 2018

 mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz 

#-----------------------------------------
#@# AParc-to-ASeg aparc Fri Feb  2 06:34:45 UTC 2018

 mri_aparc2aseg --s 3220 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /usr/local/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt 

#-----------------------------------------
#@# AParc-to-ASeg a2009s Fri Feb  2 06:46:05 UTC 2018

 mri_aparc2aseg --s 3220 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /usr/local/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s 

#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Fri Feb  2 06:57:45 UTC 2018

 mri_aparc2aseg --s 3220 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /usr/local/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz 

#-----------------------------------------
#@# APas-to-ASeg Fri Feb  2 07:08:39 UTC 2018

 apas2aseg --i aparc+aseg.mgz --o aseg.mgz 

#--------------------------------------------
#@# ASeg Stats Fri Feb  2 07:08:55 UTC 2018

 mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /usr/local/freesurfer/ASegStatsLUT.txt --subject 3220 

#-----------------------------------------
#@# WMParc Fri Feb  2 07:16:31 UTC 2018

 mri_aparc2aseg --s 3220 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz 


 mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject 3220 --surf-wm-vol --ctab /usr/local/freesurfer/WMParcStatsLUT.txt --etiv 

#--------------------------------------------
#@# BA_exvivo Labels lh Fri Feb  2 07:40:04 UTC 2018

 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA1_exvivo.label --trgsubject 3220 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA2_exvivo.label --trgsubject 3220 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA3a_exvivo.label --trgsubject 3220 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA3b_exvivo.label --trgsubject 3220 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA4a_exvivo.label --trgsubject 3220 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA4p_exvivo.label --trgsubject 3220 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA6_exvivo.label --trgsubject 3220 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA44_exvivo.label --trgsubject 3220 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA45_exvivo.label --trgsubject 3220 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.V1_exvivo.label --trgsubject 3220 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.V2_exvivo.label --trgsubject 3220 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.MT_exvivo.label --trgsubject 3220 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject 3220 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject 3220 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject 3220 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject 3220 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject 3220 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject 3220 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject 3220 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject 3220 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject 3220 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject 3220 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject 3220 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject 3220 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject 3220 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject 3220 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject 3220 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject 3220 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mris_label2annot --s 3220 --hemi lh --ctab /usr/local/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s 3220 --hemi lh --ctab /usr/local/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab 3220 lh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab 3220 lh white 

#--------------------------------------------
#@# BA_exvivo Labels rh Fri Feb  2 07:51:08 UTC 2018

 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA1_exvivo.label --trgsubject 3220 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA2_exvivo.label --trgsubject 3220 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA3a_exvivo.label --trgsubject 3220 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA3b_exvivo.label --trgsubject 3220 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA4a_exvivo.label --trgsubject 3220 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA4p_exvivo.label --trgsubject 3220 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA6_exvivo.label --trgsubject 3220 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA44_exvivo.label --trgsubject 3220 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA45_exvivo.label --trgsubject 3220 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.V1_exvivo.label --trgsubject 3220 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.V2_exvivo.label --trgsubject 3220 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.MT_exvivo.label --trgsubject 3220 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject 3220 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject 3220 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject 3220 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject 3220 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject 3220 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject 3220 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject 3220 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject 3220 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject 3220 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject 3220 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject 3220 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject 3220 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject 3220 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject 3220 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject 3220 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /usr/local/freesurfer/subjects/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject 3220 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mris_label2annot --s 3220 --hemi rh --ctab /usr/local/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s 3220 --hemi rh --ctab /usr/local/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab 3220 rh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab 3220 rh white 

