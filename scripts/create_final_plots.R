rm(list=ls())

#########################################################
# Authors: The Membrane Miners (s173461, abrisa, puqu)
# Date: December 2023
#
# Script to create figures for loss and F1 score trajectories 
#########################################################

library(tidyverse)
library(ggpubr)

#### Plots for final experiment #####
#final_exp <- read_csv("/Users/jespermadsen/Documents/Dokumenter_Anna/KBS/7_semester/DeepLearning/Project/Final_exp/output_v34.csv")
final_exp <- read_csv("/path/to/output_v34.csv")


final_exp %>%
  mutate(epoch = as.factor(epoch)) %>%
  ggplot(aes(x = step)) +
  geom_point(aes(y = `train/node_label/f1_score`, color = "Training"), size = 0.2) +
  geom_point(aes(y = `val/node_label/f1_score`, color = "Validation"), size = 0.2) +
  geom_path(aes(y = `train/node_label/f1_score`, group = ifelse(!is.na(`train/node_label/f1_score`), "Training", NA), color = "Training"), show.legend = TRUE) +
  geom_path(aes(y = `val/node_label/f1_score`, group = ifelse(!is.na(`val/node_label/f1_score`), "Validation", NA), color = "Validation"), show.legend = TRUE) +
  theme_bw() +
  #labs(title = "Loss") +
  ylab('F1 Macro') +
  scale_color_manual(values = c("Training" = "blue", "Validation" = "orange"),
                     labels = c("Training", "Validation")) +
  theme_classic() +
  theme(legend.position = c(0.2, 0.75), #legend.position = "bottom",
        legend.background = element_rect(fill = "white"),
        legend.title = element_blank(), 
        text = element_text(size = 20),
        axis.text.y=element_text(size=18))

final_exp %>%
  mutate(epoch = as.factor(epoch)) %>%
  ggplot(aes(x = step)) +
  geom_point(aes(y = `train/loss/node_label`, color = "Training"), size = 0.2) +
  geom_point(aes(y = `val/loss/node_label`, color = "Validation"), size = 0.2) +
  geom_path(aes(y = `train/loss/node_label`, group = ifelse(!is.na(`train/loss/node_label`), "Training", NA), color = "Training"), show.legend = TRUE) +
  geom_path(aes(y = `val/loss/node_label`, group = ifelse(!is.na(`val/loss/node_label`), "Validation", NA), color = "Validation"), show.legend = TRUE) +
  theme_bw() +
  #labs(title = "Loss") +
  ylab('Loss') +
  scale_color_manual(values = c("Training" = "blue", "Validation" = "orange"),
                     labels = c("Training", "Validation")) +
  theme_classic() +
  theme(legend.position = "None",
        legend.background = element_rect(fill = "white"),
        legend.title = element_blank(), 
        text = element_text(size = 20),
        axis.text.y=element_text(size=18)) 

#### Plots for final training #####

#out_micro <- read_csv("/Users/jespermadsen/Documents/Dokumenter_Anna/KBS/7_semester/DeepLearning/Project/Final_runs/Micro_end/micro_end_metrics.csv")
#out_macro <- read_csv("/Users/jespermadsen/Documents/Dokumenter_Anna/KBS/7_semester/DeepLearning/Project/Final_runs/Macro_end/macro_end_metrics.csv")
out_micro <- read_csv("/path/to/micro_end_metrics.csv")
out_macro <- read_csv("/path/to/macro_end_metrics.csv")



# Produce F1 micro plot
val_f1micro <- out_micro %>%
  mutate(epoch = as.factor(epoch)) %>%
  ggplot(aes(x = step)) +
  geom_point(aes(y = `train/node_label/f1_score`, color = "Training"), size = 0.2) +
  geom_point(aes(y = `val/node_label/f1_score`, color = "Validation"), size = 0.2) +
  geom_path(aes(y = `train/node_label/f1_score`, group = ifelse(!is.na(`train/node_label/f1_score`), "Training", NA), color = "Training"), show.legend = TRUE) +
  geom_path(aes(y = `val/node_label/f1_score`, group = ifelse(!is.na(`val/node_label/f1_score`), "Validation", NA), color = "Validation"), show.legend = TRUE) +
  theme_bw() +
  #labs(title = "Loss") +
  ylab('F1 Micro') +
  scale_color_manual(values = c("Training" = "blue", "Validation" = "orange"),
                     labels = c("Training", "Validation")) +
  theme_classic() +
  theme(legend.position = c(0.8, 0.75), #legend.position = "bottom",
        legend.background = element_rect(fill = "white"),
        legend.title = element_blank(), 
        text = element_text(size = 20),
        axis.text.y=element_text(size=18))
val_f1micro

# Produce F1 macro plot
val_f1macro <- out_macro %>%
  mutate(epoch = as.factor(epoch)) %>%
  ggplot(aes(x = step)) +
  geom_point(aes(y = `train/node_label/f1_score`, color = "Training"), size = 0.2) +
  geom_point(aes(y = `val/node_label/f1_score`, color = "Validation"), size = 0.2) +
  geom_path(aes(y = `train/node_label/f1_score`, group = ifelse(!is.na(`train/node_label/f1_score`), "Training", NA), color = "Training"), show.legend = TRUE) +
  geom_path(aes(y = `val/node_label/f1_score`, group = ifelse(!is.na(`val/node_label/f1_score`), "Validation", NA), color = "Validation"), show.legend = TRUE) +
  theme_bw() +
  #labs(title = "Loss") +
  ylab('F1 Macro') +
  scale_color_manual(values = c("Training" = "blue", "Validation" = "orange"),
                     labels = c("Training", "Validation")) +
  theme_classic() +
  theme(legend.position = "None",
        legend.background = element_rect(fill = "white"),
        legend.title = element_blank(), 
        text = element_text(size = 20),
        axis.text.x=element_text(size=18),
        axis.text.y=element_text(size=18)) 
val_f1macro

# Create loss plot for micro run
loss_micro <- out_micro %>%
  mutate(epoch = as.factor(epoch)) %>%
  ggplot(aes(x = step)) +
  geom_point(aes(y = `train/loss/node_label`, color = "Training"), size = 0.2) +
  geom_point(aes(y = `val/loss/node_label`, color = "Validation"), size = 0.2) +
  geom_path(aes(y = `train/loss/node_label`, group = ifelse(!is.na(`train/loss/node_label`), "Training", NA), color = "Training"), show.legend = TRUE) +
  geom_path(aes(y = `val/loss/node_label`, group = ifelse(!is.na(`val/loss/node_label`), "Validation", NA), color = "Validation"), show.legend = TRUE) +
  theme_bw() +
  #labs(title = "Loss (micro)") +
  ylab('Loss (micro)') +
  scale_color_manual(values = c("Training" = "blue", "Validation" = "orange"),
                     labels = c("Training", "Validation")) +
  theme_classic() +
  theme(legend.position = "None",
        legend.background = element_rect(fill = "white"),
        legend.title = element_blank(), 
        text = element_text(size = 20),
        axis.text.y=element_text(size=18)) 

# Create loss plot for macro run
loss_macro <- out_macro %>%
  mutate(epoch = as.factor(epoch)) %>%
  ggplot(aes(x = step)) +
  geom_point(aes(y = `train/loss/node_label`, color = "Training"), size = 0.2) +
  geom_point(aes(y = `val/loss/node_label`, color = "Validation"), size = 0.2) +
  geom_path(aes(y = `train/loss/node_label`, group = ifelse(!is.na(`train/loss/node_label`), "Training", NA), color = "Training"), show.legend = TRUE) +
  geom_path(aes(y = `val/loss/node_label`, group = ifelse(!is.na(`val/loss/node_label`), "Validation", NA), color = "Validation"), show.legend = TRUE) +
  theme_bw() +
  #labs(title = "Loss (macro)") +
  ylab('Loss (macro)') +
  scale_color_manual(values = c("Training" = "blue", "Validation" = "orange"),
                     labels = c("Training", "Validation")) +
  theme_classic() +
  theme(legend.position = "bottom",
        legend.background = element_rect(fill = "white"),
        legend.title = element_blank(), 
        text = element_text(size = 20),
        axis.text.y=element_text(size=18)) 

# Create common loss plot
ggarrange(loss_micro, loss_macro, nrow = 2, common.legend = TRUE)

# Create common loss and f1 plot
common_plot <- ggarrange(loss_micro, val_f1micro, val_f1macro, nrow = 3, common.legend = TRUE, legend = "bottom")



#### Plots for softmax #####

# - Micro - #
#out_softmax_micro <- read_csv("/Users/jespermadsen/Documents/Dokumenter_Anna/KBS/7_semester/DeepLearning/Project/Final_softmax/micro/softmax_metrics.csv")
out_softmax_micro <- read_csv("/path/to/micro/softmax_metrics.csv")


# F1 micro
out_softmax_micro %>%
  mutate(epoch = as.factor(epoch)) %>%
  ggplot(aes(x = step)) +
  geom_point(aes(y = `train/node_label/f1_score`, color = "Training"), size = 0.2) +
  geom_point(aes(y = `val/node_label/f1_score`, color = "Validation"), size = 0.2) +
  geom_path(aes(y = `train/node_label/f1_score`, group = ifelse(!is.na(`train/node_label/f1_score`), "Training", NA), color = "Training"), show.legend = TRUE) +
  geom_path(aes(y = `val/node_label/f1_score`, group = ifelse(!is.na(`val/node_label/f1_score`), "Validation", NA), color = "Validation"), show.legend = TRUE) +
  theme_bw() +
  #labs(title = "Loss") +
  ylab('F1 Micro') +
  scale_color_manual(values = c("Training" = "blue", "Validation" = "orange"),
                     labels = c("Training", "Validation")) +
  theme_classic() +
  theme(legend.position = c(0.8, 0.75), #legend.position = "bottom",
        legend.background = element_rect(fill = "white"),
        legend.title = element_blank(), 
        text = element_text(size = 20),
        axis.text.y=element_text(size=18))

# Loss
out_softmax_micro %>%
  mutate(epoch = as.factor(epoch)) %>%
  ggplot(aes(x = step)) +
  geom_point(aes(y = `train/loss/node_label`, color = "Training"), size = 0.2) +
  geom_point(aes(y = `val/loss/node_label`, color = "Validation"), size = 0.2) +
  geom_path(aes(y = `train/loss/node_label`, group = ifelse(!is.na(`train/loss/node_label`), "Training", NA), color = "Training"), show.legend = TRUE) +
  geom_path(aes(y = `val/loss/node_label`, group = ifelse(!is.na(`val/loss/node_label`), "Validation", NA), color = "Validation"), show.legend = TRUE) +
  theme_bw() +
  #labs(title = "Loss") +
  ylab('Loss') +
  scale_color_manual(values = c("Training" = "blue", "Validation" = "orange"),
                     labels = c("Training", "Validation")) +
  theme_classic() +
  theme(legend.position = "None",
        legend.background = element_rect(fill = "white"),
        legend.title = element_blank(), 
        text = element_text(size = 20),
        axis.text.y=element_text(size=18)) 


