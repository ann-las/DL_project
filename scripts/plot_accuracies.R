rm(list=ls())

#########################################################
# Authors: The Membrane Miners (s173461, abrisa, puqu)
# Date: December 2023
#
# Script to create figures for confusion matrix metrics
#########################################################

library(tidyverse)
library(ggpubr)

# ---------- Define values -----------

# Values for DeepTMHMM
deeptmhmm_type_correct_accuracies <- 0.9838051795959473
deeptmhmm_topology_accuracies <- c(0.8831169009208679, 1.0, 0.9649999737739563, 0.9800000190734863, 0.6875)
deeptmhmm_type_accuracies <- c(0.9740259647369385, 1.0, 0.9649999737739563, 0.9800000190734863, 1.0)


# Values for our model (based on micro end predictions and targets)
our_type_correct_accuracies <- 0.400 
our_topology_accuracies <- c(1.0, 0.0, 0.0, 1.0, 0.0)
our_type_accuracies <- c(1.0, 0.0, 0.0, 1.0, 0.0)


# Create tibble
type_correct_tibble <- tibble(protein_type = c("Overall"),
                              DeepTMHMM = deeptmhmm_type_correct_accuracies,
                              Model = our_type_correct_accuracies) %>%
  pivot_longer(cols = c(DeepTMHMM, Model), names_to = "Model", values_to = "value")

top_accuracies_tibble <- tibble(protein_type = c("TM", "TM + SP", "SP", "Glob", "Beta"),
                               DeepTMHMM = deeptmhmm_topology_accuracies,
                               Model = our_topology_accuracies) %>%
  pivot_longer(cols = c(DeepTMHMM, Model), names_to = "Model", values_to = "value")

type_accuracies_tibble <- tibble(protein_type = c("TM", "TM + SP", "SP", "Glob", "Beta"),
                                DeepTMHMM = deeptmhmm_type_accuracies,
                                Model = our_type_accuracies) %>%
  pivot_longer(cols = c(DeepTMHMM, Model), names_to = "Model", values_to = "value")


# --------- Create plots -----------

# Make plot for accuracy


# Make plot for topology
top_plot <- ggplot(data = top_accuracies_tibble, mapping = aes(x = factor(protein_type, levels = c("TM", "TM + SP", "SP", "Glob", "Beta")), y = value*100, fill = factor(Model, levels = c("Model", "DeepTMHMM")))) +
  geom_col(position = "dodge") + 
  theme_classic() +
  xlab("") +
  ylab("% topology accuracy") +
  scale_y_continuous(breaks = round(seq(0, 100 , by = 10))) +
  theme(legend.position = "none")

# Make plot for overall
overall_plot <- ggplot(data = type_correct_tibble, mapping = aes(x = factor(protein_type), y = value*100, fill = factor(Model, levels = c("Model", "DeepTMHMM")))) +
  geom_col(position = "dodge") + 
  theme_classic() +
  xlab("  ") +
  ylab("Type accuracy") + # Maybe add this to overall
  scale_y_continuous(breaks = round(seq(0, 100 , by = 10))) +
  theme(axis.text.y=element_blank(),axis.ticks=element_blank(),
        axis.title.y=element_blank(),
        #legend.position="none",
        axis.line.y = element_blank(),
        legend.title = element_blank())

# Make plot for type
type_plot <- ggplot(data = type_accuracies_tibble, mapping = aes(x = factor(protein_type, levels = c("TM", "TM + SP", "SP", "Glob", "Beta")), y = value*100, fill = factor(Model, levels = c("Model", "DeepTMHMM")))) +
  geom_col(position = "dodge") + 
  theme_classic() +
  xlab(" ") +
  ylab("% type accuracy") +
  scale_y_continuous(breaks = round(seq(0, 100 , by = 10))) + 
  theme(legend.position="none",
        legend.title = element_blank())

top_plot
ggarrange(type_plot, overall_plot, common.legend = TRUE, legend = "bottom", widths = c(8,2))
s

