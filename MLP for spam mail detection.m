function [net,y,ypsc]=askisi4bspam(~)

clear 
clc
%data input
load('spamdata.mat')

%mix the data randomly
n=size(dat);
dat = dat(randperm(n(1)),:);

%spliting input/output data
x=dat(:,1:57);
y=dat(:,58);

%data normalization
[xsc,ps_xsc]=mapminmax(x');

%create neural network
net = patternnet([20 10]);

%defining the train/validate/test data
a=1;
b=round(0.4*n(1));
c=b+1;
d=c+round(0.3*n(1));
e=d+1;
f=n(1);
net.divideFcn = 'divideind';
net.divideParam.trainInd = a:b;
net.divideParam.valInd = c:d;
net.divideParam.testInd = e:f;
net.trainFcn='trainscg';

%creating a matrix with the output train data
Yreverse=not(y);
Y=[y Yreverse];

%training
net.trainFcn='trainscg';
[net,tr] = train(net,xsc,Y');

%predictions
Yp = net(xsc);

%transforming the predictions to 1 or 0
for i=1:n(1)
    if Yp(1,i)>Yp(2,i)
        Yp(1,i)=1;
        Yp(2,i)=0;
    else
        Yp(1,i)=0;
        Yp(2,i)=1;
    end
end
Yp=Yp';

% mails that categorized correclty (train)
CCtrain=0;
for i=a:b
    if Y(i,1) == Yp(i,1)'
CCtrain = CCtrain + 1;
    end
end
CCtrain = CCtrain*100/(b-a+1);

% mails that categorized correclty (validation)
CCval=0;

for i=c:d
    if Y(i,1) == Yp(i,1)'
CCval = CCval + 1;
    end
end
CCval = CCval*100/(d-c+1);

% mails that categorized correclty (test)
CCtest=0;
for i=e:f
    if Y(i,1) == Yp(i,1)'
CCtest = CCtest + 1;
    end
end
CCtest = CCtest*100/(f-e+1);

% spam-correct (train)
AAtrain=0;
for i=a:b
    if Y(i,1) == 1 && Yp(i,1)' == 1;
AAtrain = AAtrain + 1;
    end
end
AAtrain = AAtrain*100/(b-a+1);

% spam-correct (validation)
AAval=0;

for i=c:d
    if Y(i,1) == 1 && Yp(i,1)'== 1;
AAval = AAval + 1;
    end
end
AAval = AAval*100/(d-c+1);

% spam-correct (test)
AAtest=0;
for i=e:f
    if Y(i,1) ==1 && Yp(i,1)' == 1;
AAtest = AAtest + 1;
    end
end
AAtest = AAtest*100/(f-e+1);

%  NOTspam-correct (train)
BBtrain=0;
for i=a:b
    if Y(i,1) == 0 && Yp(i,1)' == 0;
BBtrain = BBtrain + 1;
    end
end
BBtrain = BBtrain*100/(b-a+1);

% NOTspam-correct (validation)
BBval=0;

for i=c:d
    if Y(i,1) == 0 && Yp(i,1)'== 0;
BBval = BBval + 1;
    end
end
BBval = BBval*100/(d-c+1);

% NOTspam-correct (test)
BBtest=0;
for i=e:f
    if Y(i,1) == 0 && Yp(i,1)' == 0;
BBtest = BBtest + 1;
    end
end
BBtest = BBtest*100/(f-e+1);

%  spam detection failure (train)
BAtrain=0;
for i=a:b
    if Y(i,1) == 1 && Yp(i,1)' == 0;
BAtrain = BAtrain + 1;
    end
end
BAtrain = BAtrain*100/(b-a+1);

% spam detection failure (validation)
BAval=0;

for i=c:d
    if Y(i,1) == 1 && Yp(i,1)' == 0;
BAval = BAval + 1;
    end
end
BAval = BAval*100/(d-c+1);

% spam detection failure (test)
BAtest=0;
for i=e:f
    if Y(i,1) == 1 && Yp(i,1)' == 0;
BAtest = BAtest + 1;
    end
end
BAtest = BAtest*100/(f-e+1);

%  spam false alarm (train)
ABtrain=0;
for i=a:b
    if Y(i,1) == 0 && Yp(i,1)' == 1;
ABtrain = ABtrain + 1;
    end
end
ABtrain = ABtrain*100/(b-a+1);

%  spam false alarm (train)
ABval=0;

for i=c:d
    if Y(i,1) == 0 && Yp(i,1)' == 1;
ABval = ABval + 1;
    end
end
ABval = ABval*100/(d-c+1);

%  spam false alarm (train)
ABtest=0;
for i=e:f
    if Y(i,1) ==0 && Yp(i,1)' == 1;
ABtest = ABtest + 1;
    end
end
ABtest = ABtest*100/(f-e+1);



end





