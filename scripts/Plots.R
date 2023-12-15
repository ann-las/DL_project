setwd("~/OneDrive - Danmarks Tekniske Universitet/PhD/Courses/DeepLearning/Project")

library(tidyverse)

out <- read_csv("./out.csv")
out_34 <- read_csv("./output_v34.csv")
out_v2 <- read_csv("./output_micro_c.csv") #read_csv("./output_expC_v2.csv")
out_v5 <- read_csv("./output_macro_c.csv") #read_csv("./output_macro_v5.csv")

# Loss Both ---------------------------------------------

# F1 Macro CV0 
loss_both <- out_34 %>%
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
  theme(legend.position = "bottom",
        legend.background = element_rect(fill = "white"),
        legend.title = element_blank(), 
        text = element_text(size = 20),
        axis.text.y=element_text(size=18))  #+  # Set the text size
  #scale_x_continuous(limits=out_34$epoch,breaks=out_34$epoch[seq(1,length(out_34$epoch),by=2)])  

ggsave(loss_both, file = './results/Loss_both_f1macro_v34.png')

# Micro F1 Full set ---
loss_both <- out_v2 %>%
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
  theme(legend.position = "bottom",
        legend.background = element_rect(fill = "white"),
        legend.title = element_blank(), 
        text = element_text(size = 20),
        axis.text.y=element_text(size=18)) 
ggsave(loss_both, file = './results/Loss_both_f1micro_v2.png')

# Macro F1 Full set 
loss_both <- out_v5 %>%
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
  theme(legend.position = "bottom",
        legend.background = element_rect(fill = "white"),
        legend.title = element_blank(), 
        text = element_text(size = 20),
        axis.text.y=element_text(size=18)) 
ggsave(loss_both, file = './results/Loss_both_f1macro_v5.png')







# # Validation accuracy----
# out <- read_csv("./out.csv")
# out %>% filter(!is.na(`val/node_label/accuracy`)) %>%
#   mutate(epoch = factor(epoch)) %>%
#   ggplot(aes(x = epoch, y = `val/node_label/accuracy`)) +
#   geom_point()+
#   geom_path(aes(group = 1))+
#   theme_bw() +
#   scale_x_discrete(limits = levels(factor(0:160))) +
#   labs(title = "Validation acc on node labels")
# 
# # Validation f1score
# out %>% filter(!is.na(`val/node_label/f1_score`)) %>%
#   mutate(epoch = factor(epoch)) %>%
#   ggplot(aes(x = epoch, y = `val/node_label/f1_score`)) +
#   geom_point()+
#   geom_path(aes(group = 1))+
#   theme_bw() +
#   scale_x_discrete(limits = levels(factor(0:80))) +
#   labs(title = "Validation F1 Macro score on node labels")+
#   theme(text = element_text(size = 18),
#         axis.text.y=element_text(size=16))

val_f1 <- out_34 %>%
  mutate(epoch = as.factor(epoch)) %>%
  ggplot(aes(x = step)) +
  geom_point(aes(y = `train/node_label/f1_score`, color = "Training"), size = 0.2) +
  geom_point(aes(y = `val/node_label/f1_score`, color = "Validation"), size = 0.2) +
  geom_path(aes(y = `train/node_label/f1_score`, group = ifelse(!is.na(`train/node_label/f1_score`), "Training", NA), color = "Training"), show.legend = TRUE) +
  geom_path(aes(y = `val/node_label/f1_score`, group = ifelse(!is.na(`val/node_label/f1_score`), "Validation", NA), color = "Validation"), show.legend = TRUE) +
  theme_bw() +
  #labs(title = "Loss") +
  ylab('F1_score:Macro') +
  scale_color_manual(values = c("Training" = "blue", "Validation" = "orange"),
                     labels = c("Training", "Validation")) +
  theme(legend.position = "bottom",
        legend.background = element_rect(fill = "white"),
        legend.title = element_blank(), 
        text = element_text(size = 20),
        axis.text.y=element_text(size=18)) 
ggsave(val_f1, file = './results/Val_f1macro_v34.png')

# Micro 
# val_f1 <- out_v2 %>% filter(!is.na(`val/node_label/f1_score`)) %>% 
#   mutate(epoch = factor(epoch)) %>% 
#   ggplot(aes(x = epoch, y = `val/node_label/f1_score`)) +
#   geom_point()+ 
#   geom_path(aes(group = 1))+
#   theme_bw() +
#   scale_x_discrete(limits = levels(factor(0:70))) +
#   labs(title = "Validation F1 Micro score on node labels")+
#   theme(text = element_text(size = 18),
#         axis.text.y=element_text(size=16)) 

val_f1 <- out_v2 %>%
  mutate(epoch = as.factor(epoch)) %>%
  ggplot(aes(x = step)) +
  geom_point(aes(y = `train/node_label/f1_score`, color = "Training"), size = 0.2) +
  geom_point(aes(y = `val/node_label/f1_score`, color = "Validation"), size = 0.2) +
  geom_path(aes(y = `train/node_label/f1_score`, group = ifelse(!is.na(`train/node_label/f1_score`), "Training", NA), color = "Training"), show.legend = TRUE) +
  geom_path(aes(y = `val/node_label/f1_score`, group = ifelse(!is.na(`val/node_label/f1_score`), "Validation", NA), color = "Validation"), show.legend = TRUE) +
  theme_bw() +
  #labs(title = "Loss") +
  ylab('F1_score:Micro') +
  scale_color_manual(values = c("Training" = "blue", "Validation" = "orange"),
                     labels = c("Training", "Validation")) +
  theme(legend.position = "bottom",
        legend.background = element_rect(fill = "white"),
        legend.title = element_blank(), 
        text = element_text(size = 20),
        axis.text.y=element_text(size=18)) 

ggsave(val_f1, file = './results/Val_f1micro_v2.png')


# V5

# val_f1 <- out_v5 %>% filter(!is.na(`val/node_label/f1_score`)) %>% 
#   mutate(epoch = factor(epoch)) %>% 
#   ggplot(aes(x = epoch, y = `val/node_label/f1_score`)) +
#   geom_point()+ 
#   geom_path(aes(group = 1))+
#   theme_bw() +
#   scale_x_discrete(limits = levels(factor(0:70))) +
#   labs(title = "Validation F1 Macro score on node labels")+
#   theme(text = element_text(size = 18),
#         axis.text.y=element_text(size=16)) 


val_f1_both <- out_v5 %>%
  mutate(epoch = as.factor(epoch)) %>%
  ggplot(aes(x = step)) +
  geom_point(aes(y = `train/node_label/f1_score`, color = "Training"), size = 0.2) +
  geom_point(aes(y = `val/node_label/f1_score`, color = "Validation"), size = 0.2) +
  geom_path(aes(y = `train/node_label/f1_score`, group = ifelse(!is.na(`train/node_label/f1_score`), "Training", NA), color = "Training"), show.legend = TRUE) +
  geom_path(aes(y = `val/node_label/f1_score`, group = ifelse(!is.na(`val/node_label/f1_score`), "Validation", NA), color = "Validation"), show.legend = TRUE) +
  theme_bw() +
  #labs(title = "Loss") +
  ylab('F1_score:Macro') +
  scale_color_manual(values = c("Training" = "blue", "Validation" = "orange"),
                     labels = c("Training", "Validation")) +
  theme(legend.position = "bottom",
        legend.background = element_rect(fill = "white"),
        legend.title = element_blank(), 
        text = element_text(size = 20),
        axis.text.y=element_text(size=18)) 

ggsave(val_f1_both, file = './results/Val_f1macro_v5.png')
