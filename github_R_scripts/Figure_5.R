library(ggplot2)
library(dplyr)
library(tidyverse)
library(vegan)
library(rcartocolor)
library(RColorBrewer)
library(pals)
library(ggsci)
library(lubridate)
library(patchwork)

snvs<-read.table("new_test_table.txt", header = TRUE, sep = '\t')

snvs$Date.1<-ymd(snvs$Date.1)

ps1<-ggplot(snvs, aes(y = POS, x = snvs$Date.1,
                      color = snvs$Library_prep)) + 
  scale_color_brewer(palette = "Dark2")+
  geom_point(color = "black", size = 0.9)+
  geom_point(size = 0.8)

ps2<-ps1 + theme_bw()
ps3<-ps2
ps4<-ps3
ps5<-ps4 + theme(axis.title.x = element_text(face = "bold", size = 14),
                 legend.text = element_text(face = "bold", size = 12),
                 axis.title.y = element_text(face = "bold", size = 14), 
                 legend.title  = element_text(face = "bold", size = 14),
                 axis.text.x = element_text(face = "bold", size = 10, color = "black",
                                            angle = 90, h = 0.5, v = 0.5),
                 axis.ticks = element_line(color = "black"),
                 panel.grid.major = element_line(color = "black", size = 0.2),
                 panel.grid.minor = element_blank(),
                 axis.text.y = element_text(face = "bold", size = 12, color = "black"),
                 legend.position = "bottom")+
  scale_y_continuous(
    limits = c(0,30000), breaks = scales::pretty_breaks(n=10),expand = c(0.001,0.001)) + 
  expand_limits(y = 1)+
  scale_x_date(date_breaks = "14 days", expand =c(0.02,0.02)) +
  ylab("Genomic Position") + xlab("\nSampling Date") + 
  labs(color = "Library Prep Method")+
  guides(color = guide_legend(override.aes = list(size = 3)))

un<-unique(snvs$POS)
tab<-table(snvs$Date.1)
tab<-as.data.frame(tab)
tab$Var1<-ymd(tab$Var1)
pb1<-ggplot(tab, aes(y = tab$Freq, x = as.Date(Var1), color = "black")) + 
  geom_point(color= "black", size = 0.8) +
  geom_segment( aes(x=Var1, xend=Var1, y=0, yend=Freq), color = "black", size = 0.5)
pb2<-pb1 +
  scale_x_date(date_breaks = "14 days", expand =c(0.02,0.02)) + theme_bw()
pb3 <-pb2+ theme(legend.text = element_text(face = "bold", size = 12),
  axis.title.y = element_text(face = "bold", size = 14),
  axis.title.x = element_blank(),
  legend.title  = element_text(face = "bold", size = 14),
  axis.text.x = element_blank(),
  axis.ticks.x = element_blank(),
  panel.grid.major = element_line(color = "black", size = 0.2),
  panel.grid.minor = element_blank(),
  axis.ticks = element_line(color = "black"),
  axis.text.y = element_text(face = "bold", size = 12, color = "black"))+
  expand_limits(y = 1) +
  scale_y_continuous(limits = c(0,400),breaks = scales::pretty_breaks(n = 10), expand = c(0.001,0.001))+
  ylab("Number of SNVs Detected") + xlab("Sampling Date")

data<-read.table("ILR_snvs_position.txt", sep = '\t', quote = "", 
                 header = TRUE)

ps1<-ggplot(data, aes(x = Position, y = Frequency)) + 
  geom_point(color= "black", size = 0.8) +
  geom_segment( aes(x=Position, xend=Position, y=0, yend=Frequency), size = 0.5)
ps2<-ps1 + theme_bw()
ps3<-ps2
ps4<-ps3
psirv5<-ps4 + theme(legend.text = element_text(face = "bold", size = 12),
  axis.title.y = element_text(face = "bold", size = 14),
  axis.title.x = element_text(face = "bold", size = 14),
  legend.title  = element_text(face = "bold", size = 14),
  axis.text.x = element_text(face = "bold", size = 12, color = "black",
                             angle = 90, h = 0.5, v = 0.5),
  panel.grid.major = element_line(color = "black", size = 0.2),
  panel.grid.minor = element_blank(),
  axis.ticks = element_line(color = "black"),
  axis.text.y = element_text(face = "bold", size = 12, color = "black"))+
  scale_x_continuous(
    limits = c(0,30000), breaks = scales::pretty_breaks(n=10),expand = c(0.0001,0.0001)) + 
  expand_limits(y = 1) +
  scale_y_continuous(limits = c(0,42),breaks = scales::pretty_breaks(n = 17), expand = c(0.001,0.001))+
  ylab("Frequency of SNV Detected") + xlab("\n Genomic Position")
psirv5

data<-read.table("tiledamplicon_snvs_position.txt", sep = '\t', quote = "", 
                 header = TRUE)

ps1<-ggplot(data, aes(x = Position, y = Frequency)) + 
  geom_point(color= "black", size = 0.8) +
  geom_segment( aes(x=Position, xend=Position, y=0, yend=Frequency), size = 0.5)
ps2<-ps1 + theme_bw()
ps3<-ps2
ps4<-ps3
psamp5<-ps4 + theme(legend.text = element_text(face = "bold", size = 12),
  axis.title.y = element_text(face = "bold", size = 14),
  axis.title.x = element_text(face = "bold", size = 14),
  legend.title  = element_text(face = "bold", size = 14),
  axis.text.x = element_text(face = "bold", size = 12, color = "black",
                             angle = 90, h = 0.5, v = 0.5),
  panel.grid.major = element_line(color = "black", size = 0.2),
  panel.grid.minor = element_blank(),
  axis.ticks = element_line(color = "black"),
  axis.text.y = element_text(face = "bold", size = 12, color = "black"))+
  scale_x_continuous(
    limits = c(0,30000), breaks = scales::pretty_breaks(n=10),expand = c(0.001,0.001)) + 
  expand_limits(y = 1) +
  scale_y_continuous(limits = c(0,55),breaks = scales::pretty_breaks(n = 17), expand = c(0.001,0.001))+
  ylab("Frequency of SNV Detected") + xlab("\nGenomic Position")

((pb3/ps5)/(psirv5+psamp5)) + plot_annotation(tag_levels = 'A')+ 
  plot_layout(guides = "collect") & 
  theme(legend.position = "bottom",
        plot.tag = element_text(size = 18, 
                                face = "bold"))
