## Copyright (C) 2020 Pablo Alvarado
##
## Este archivo forma parte del material del curso:
## EL5852 Introducci�n al Reconocimiento de Patrones
## Escuela de Ingenier�a Electr�nica
## Tecnol�gico de Costa Rica

1;
pkg load specfun;
pkg load statistics;
n=10; #muestras
nw1 = 10; #peso capa 1
nw2 = 4;#peso capa 2
nw3 = 4;#peso capa 3
c=4; #clases
[X,Y] = create_data(n,c, "vertical");

## Capas:
l1a=fullyconnected();
l1b=sigmoide();
l2a=fullyconnected();
l2b=leaky();
l3a=fullyconnected();
l3b=ReLU();
l4a=fullyconnected();
l4b=sigmoide();

## Forward prop
x  = X;
x = [x ones(rows(x),1)];
W1 = w_gen(columns(x),nw1)';
W2 = w_gen(nw1+1,nw2)';
W3 = w_gen(nw2+1,nw3)';
W4 = w_gen(nw3+1,c)';
yt = Y;

counter =0;
while counter < 500
y1a=l1a.forward(W1,x);
y1b=l1b.forward(y1a);

y1b=[y1b ones(rows(y1b),1)];

y2a=l2a.forward(W2,y1b);
y2b=l2b.forward(y2a);

y2b=[y2b ones(rows(y2b),1)];

y3a=l3a.forward(W3,y2b);
y3b=l3b.forward(y3a);

y3b=[y3b ones(rows(y3b),1)];

y4a=l4a.forward(W4,y3b);
y4b=l4b.forward(y4a);

J = mse();

error = J.error(y4b,yt);
gradJ = J.gradient;
error
## Backprop.

l4b.backward(gradJ); # asumiendo que esto es el final
l4a.backward(l4b.gradient);

l3b.backward(l4a.gradientX(2,2:end));
l3a.backward(l3b.gradient);

l2b.backward(l3a.gradientX(2,2:end));
l2a.backward(l2b.gradient);

l1b.backward(l2a.gradientX(2,2:end));
l1a.backward(l1b.gradient);

alpha = 0.01; ################################
W1 = W1 - alpha*l1a.gradientW;
W2 = W2 - alpha*l2a.gradientW;
W3 = W3 - alpha*l3a.gradientW;
W4 = W4 - alpha*l4a.gradientW;

counter += 1;

end
X
y4b

yt