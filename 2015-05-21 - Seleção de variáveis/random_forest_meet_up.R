setwd("C:/Users/Cacá Relvas/Desktop/blog/")

dados = read.table("spambase.data", sep=",", header=F)
nomes = c("word_freq_make",  "word_freq_address",  "word_freq_all",  "word_freq_3d",	
          "word_freq_our",	"word_freq_over",	"word_freq_remove",	"word_freq_internet",
          "word_freq_order",	"word_freq_mail",	"word_freq_receive",	"word_freq_will",
          "word_freq_people",	"word_freq_report",	"word_freq_addresses",	"word_freq_free",	
          "word_freq_business",	"word_freq_email",	"word_freq_you",	"word_freq_credit",
          "word_freq_your",	"word_freq_font",	"word_freq_000",	"word_freq_money",
          "word_freq_hp",	"word_freq_hpl",	"word_freq_george",	"word_freq_650",
          "word_freq_lab",	"word_freq_labs",	"word_freq_telnet",	"word_freq_857",
          "word_freq_data",	"word_freq_415",	"word_freq_85",	"word_freq_technology",
          "word_freq_1999",	"word_freq_parts",	"word_freq_pm",	"word_freq_direct",	
          "word_freq_cs",	"word_freq_meeting",	"word_freq_original",	"word_freq_project",
          "word_freq_re",	"word_freq_edu",	"word_freq_table",	"word_freq_conference",	
          "char_freq_pvir",	"char_freq_par",	"char_freq_bra",	"char_freq_exc",
          "char_freq_dolar", "char_freq_num",	"capital_run_length_average",
          "capital_run_length_longest", "capital_run_length_total",	"SPAM")
names(dados) = nomes
set.seed(432)
id <- sample(1:nrow(dados), nrow(dados)*0.8)
id.des <- sample(id, nrow(dados)*0.7)
id.val <- id[!(id %in% id.des)]
dados.des <- dados[id.des,]
dados.val <- dados[id.val,]
dados.test <- dados[-id,]

formula = paste0("as.factor(", nomes[58], ") ~ ", paste0(nomes[1:57], collapse="+"))

install.packages("ROCR")

diag = function(obs, prev){
  library(ROCR)
  pred = prediction(prev, obs)
  perf = performance(pred,"auc")
  GINI=2*attr(perf,'y.values')[[1]]-1
  return(GINI)
}


## STEPWISE

ptm <- proc.time()
fit = glm(as.formula(formula), data=dados.des, family="binomial")
st = step(fit)
proc.time() - ptm

#usuário   sistema decorrido 
#497.22      4.03    502.06 

diag(dados.des[,"V58"], predict(st, newdata=dados.des))
diag(dados.test[,"V58"], predict(st, newdata=dados.test))
diag(dados.val[,"V58"], predict(st, newdata=dados.val))

## Number of variables
length(st$coefficients)-1



## RandomForest

install.packages("randomForest")
library(randomForest)

ptm <- proc.time()
rf = randomForest(as.formula(formula), data=dados.des, ntree=500, importance=TRUE)
proc.time() - ptm

#usuário   sistema decorrido 
#34.55      0.00     34.56 

vars.rank = names(sort(rf$importance[,"MeanDecreaseGini"], decreasing=T))
plot(sort(rf$importance[,"MeanDecreaseGini"], decreasing=T), xlab="Variable",
     ylab="MeanDecreaseGini", pch=16, main="Variable importance")
varImpPlot(rf)

layout(matrix(c(1,2),nrow=1),
       width=c(4,1)) 
par(mar=c(5,4,4,0)) #No margin on the right side
plot(rf, log="y")
par(mar=c(5,0,4,2)) #No margin on the left side
plot(c(0,1),type="n", axes=F, xlab="", ylab="")
legend("top", colnames(rf$err.rate),col=1:4,cex=0.8,fill=1:4)

formula.rf = paste0("as.factor(", nomes[58], ") ~ ",
                    paste0(paste0(vars.rank[1:42]), collapse="+"))
fit.rf = glm(as.formula(formula.rf), family=binomial, data=dados.des)
diag(dados.des[,"SPAM"], predict(fit.rf, newdata=dados.des))
diag(dados.test[,"SPAM"], predict(fit.rf, newdata=dados.test))
diag(dados.val[,"SPAM"], predict(fit.rf, newdata=dados.val))


formula.rf = paste0("as.factor(", nomes[58], ") ~ ", paste0(paste0(vars.rank[1:42]),
                                                collapse="+"))
fit.rf = glm(as.formula(formula.rf), family=binomial, data=dados.des)
diag(dados.des[,"SPAM"], predict(fit.rf, newdata=dados.des))
diag(dados.test[,"SPAM"], predict(fit.rf, newdata=dados.test))
diag(dados.val[,"SPAM"], predict(fit.rf, newdata=dados.val))


library(caret)

fitControl <- trainControl(method = "oob")

rfGrid <-  expand.grid(.mtry=c(5,7,10,15))

formula = paste0("as.factor(", nomes[58], ") ~ ", paste0(nomes[1:57], collapse="+"))

set.seed(4322)
ptm <- proc.time()
fit <- train(as.formula(formula), data = dados.des,
             method = "rf",
             trControl = fitControl,
             metric = "Accuracy", ntree=500,
             tuneGrid = rfGrid)
proc.time() - ptm


