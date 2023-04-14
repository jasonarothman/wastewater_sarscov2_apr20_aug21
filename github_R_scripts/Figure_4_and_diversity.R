library(ggplot2)
library(dplyr)
library(tidyverse)
library(vegan)
library(rcartocolor)
library(RColorBrewer)
library(pals)
library(ggsci)
library(lmerTest)
library(patchwork)
library(reshape2)
library(ggrepel)

data<-read.table("all_tiled_amplicon_freyja_demix_subclades_abundance_R_readable.tsv", sep = '\t', quote = "", 
                 header = TRUE, dec = ".")

data$Wastewater<-NULL

casted<-dcast(data, formula = Clade~Sample)
casted[is.na(casted)] <- 0

var<-read.table("metadata_all_samples.txt", header = TRUE, sep ='\t')
data_norm <-casted
data_norm<-data.frame(data_norm, row.names = 1)
data_norm<-t(data_norm)

var<-var %>%
  filter(var$AMP_subclade == "Y")
var<-data.frame(var, row.names = 1)
var<-var[ order(row.names(var)), ]

data_nmds <- metaMDS(data_norm, distance = 'bray', autotransform = F, 
                     k = 2, noshare = F, trymax = 100, parallel = 6)
nmds_scores<-scores(data_nmds)
nmds_df<-as.data.frame(nmds_scores)

detach(var)
attach(var)
for_plotting<-merge(nmds_df,var, by = "row.names")

for_plotting$Month<-factor(for_plotting$Month, levels = c("APR_20",
                                                          "MAY_20",
                                                          "JUN_20",
                                                          "JUL_20",
                                                          "AUG_20",
                                                          "SEPT_20",
                                                          "OCT_20",
                                                          "NOV_20",
                                                          "DEC_20",
                                                          "JAN_21",
                                                          "FEB_21",
                                                          "MAR_21",
                                                          "APR_21",
                                                          "MAY_21",
                                                          "JUN_21",
                                                          "JUL_21",
                                                          "AUG_21"))

p1<-ggplot(for_plotting, aes(NMDS1, NMDS2, color = Plant)) + 
  scale_color_brewer(palette = "Dark2") +
  geom_label_repel(aes(label = Month, fontface = "bold"), max.overlaps = Inf)

n <- 17
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))

p1<-ggplot(for_plotting, aes(NMDS1, NMDS2, color = Month))+
  geom_label_repel(aes(label = Month, fontface = "bold"), max.overlaps = Inf)+
  scale_color_manual(values=col_vector)

p2<-p1 + theme_bw()
p3<-p2 + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p4<-p3
p5_mds<-p4 + theme(axis.title.x = element_text(face = "bold", size = 14),
                   legend.text = element_text(face = "bold", size = 12),
                   axis.title.y = element_text(face = "bold", size = 14), 
                   legend.title  = element_text(face = "bold", size = 14))
p6_mds_amp <- p5_mds + facet_grid(~Plant) +
  theme(strip.background = element_blank(),
        strip.text = element_text(face = "bold", size = 14))

p6_mds_amp

bray<- vegdist(data_norm, method = 'bray')

ad<-adonis(data_norm ~ Plant * Month + Batch, 
           data = var, parallel = 4,
           method = "bray")
ad

shannon<-diversity(data_norm, index = "shannon")

for_plotting<-merge(var,shannon, by='row.names')
shapiro.test(shannon)
hist(shannon)
qqnorm(shannon)

shannon_krusk<-kruskal.test(shannon~Month, data = for_plotting)
shannon_krusk
shannon_krusk<-kruskal.test(shannon~Plant, data = for_plotting)
shannon_krusk


shannon_lmer<-lmer(shannon ~ as.numeric(as.factor(Days_from_4_21_20)) + 
                     (1|Plant) + (1|Batch), data = var)
summary(shannon_lmer)  

data<-read.table("all_ILR_freyja_demix_sublineages_abundance_R_readable.tsv", sep = '\t', quote = "", 
                 header = TRUE, dec = ".")

casted<-dcast(data, formula = Clade~Sample)
casted[is.na(casted)] <- 0

var<-read.table("metadata_all_samples.txt", header = TRUE, sep ='\t')
data_norm <-casted

data_norm<-data.frame(data_norm, row.names = 1)
data_norm<-t(as.matrix(data_norm))

var<-var %>%
  filter(var$IRV_subclade == "Y")
var<-data.frame(var, row.names = 1)
data_norm<-as.data.frame(data_norm)
var<-var[ order(row.names(var)), ]
data_norm<-data_norm %>%
  filter(var$Month == "AUG_20" | var$Month == "SEPT_20" | var$Month == "OCT_20" | 
           var$Month == "NOV_20")
data_norm<-as.matrix(data_norm)

var<-var %>%
  filter(var$Month == "AUG_20" | var$Month == "SEPT_20" | var$Month == "OCT_20" | 
           var$Month == "NOV_20")
data_norm<-as.data.frame(data_norm)
data_norm<-data_norm %>%
  filter(var$Plant != "NC")
data_norm<-as.matrix(data_norm)

var<-var %>%
  filter(var$Plant != "NC")

data_nmds <- metaMDS(data_norm, distance = 'bray', autotransform = F, 
                     k = 2, noshare = F, trymax = 100, parallel = 6)
nmds_scores<-scores(data_nmds)
nmds_df<-as.data.frame(nmds_scores)

detach(var)
attach(var)
for_plotting<-merge(nmds_df,var, by = "row.names")
for_plotting$Month<-factor(for_plotting$Month, levels = c("AUG_20",
                                                          "SEPT_20",
                                                          "OCT_20",
                                                          "NOV_20"))
p1<-ggplot(for_plotting, aes(NMDS1, NMDS2, color = Plant)) + 
  scale_color_brewer(palette = "Dark2") +
  geom_label_repel(aes(label = Month, fontface = "bold"), max.overlaps = Inf)


p2<-p1 + theme_bw()
p3<-p2 + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p4<-p3
p5_mds<-p4 + theme(axis.title.x = element_text(face = "bold", size = 14),
                   legend.text = element_text(face = "bold", size = 12),
                   axis.title.y = element_text(face = "bold", size = 14), 
                   legend.title  = element_text(face = "bold", size = 14))
p5_mds_irv<-p5_mds

bray<- vegdist(data_norm, method = 'bray')

ad<-adonis(data_norm ~ Plant * Month + Batch,  
           data = var, parallel = 4, 
           method = "bray")
ad

shannon<-diversity(data_norm, index = "shannon")

for_plotting<-cbind(nmds_df,var,shannon)

shapiro.test(shannon)
hist(shannon)
qqnorm(shannon)
shannon_krusk<-kruskal.test(shannon~Month, data = for_plotting)
shannon_krusk

shannon_lmer<-lmer(shannon ~ as.numeric(as.factor(Days_from_4_21_20)) + 
                     (1|Plant) + (1|Batch), data = for_plotting)
summary(shannon_lmer)  


data<-read.table("all_ILR_freyja_demix_sublineages_abundance_R_readable.tsv", sep = '\t', quote = "", 
                 header = TRUE, dec = ".")

casted<-dcast(data, formula = Clade~Sample)
casted[is.na(casted)] <- 0

var<-read.table("metadata_all_samples.txt", header = TRUE, sep ='\t')
data_norm <-casted
data_norm<-data.frame(data_norm, row.names = 1)
data_norm<-t(data_norm)

var<-var %>%
  filter(var$IRV_subclade == "Y")

var<-data.frame(var, row.names = 1)
var<-var[ order(row.names(var)), ]
data_norm<-as.data.frame(data_norm)

data_norm<-data_norm %>%
  filter(var$Plant == "ESC" | var$Plant == "HTP" | var$Plant == "PL")
data_norm<-as.matrix(data_norm)
rownames(data_norm)
var<-var %>%
  filter(var$Plant == "ESC" | var$Plant == "HTP" | var$Plant == "PL")

data_nmds <- metaMDS(data_norm, distance = 'bray', autotransform = F, 
                     k = 2, noshare = F, trymax = 100, parallel = 6)
nmds_scores<-scores(data_nmds)
nmds_df<-as.data.frame(nmds_scores)

detach(var)
attach(var)
for_plotting<-merge(nmds_df,var, by = "row.names")
for_plotting$Month<-factor(for_plotting$Month, levels = c("JUL_20",
                                                          "AUG_20",
                                                          "SEPT_20",
                                                          "OCT_20",
                                                          "NOV_20",
                                                          "DEC_20",
                                                          "JAN_21",
                                                          "FEB_21",
                                                          "MAR_21",
                                                          "APR_21",
                                                          "MAY_21",
                                                          "JUN_21",
                                                          "JUL_21",
                                                          "AUG_21"))
n <- 14
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))

p1<-ggplot(for_plotting, aes(NMDS1, NMDS2, color = Month))+
  geom_label_repel(aes(label = Month, fontface = "bold"), max.overlaps = Inf)+
  scale_color_manual(values=col_vector)

p2<-p1 + theme_bw()
p3<-p2 + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p4<-p3
p5_mds_long<-p4 + theme(axis.title.x = element_text(face = "bold", size = 14),
                        legend.text = element_text(face = "bold", size = 12),
                        axis.title.y = element_text(face = "bold", size = 14), 
                        legend.title  = element_text(face = "bold", size = 14))

p6_mds_long<-p5_mds_long+ facet_grid(~Plant) +
  theme(strip.background = element_blank(),
        strip.text = element_text(face = "bold", size = 14))

(p6_mds_long / p6_mds_amp)+ 
  plot_annotation(tag_levels = 'A') & 
  theme(plot.tag = element_text(size = 18,face = "bold"))

bray<- vegdist(data_norm, method = 'bray')

ad<-adonis(data_norm ~ Plant * Month + Batch,  
           data = var, parallel = 4, 
           method = "bray")
ad

shannon<-diversity(data_norm, index = "shannon")

for_plotting<-cbind(nmds_df,var,shannon)

shapiro.test(shannon)
hist(shannon)
qqnorm(shannon)

shannon_krusk<-kruskal.test(shannon~Month, data = for_plotting)
shannon_krusk

shannon_krusk<-kruskal.test(shannon~Plant, data = for_plotting)
shannon_krusk
