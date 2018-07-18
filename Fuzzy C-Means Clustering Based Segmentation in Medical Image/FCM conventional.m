% Conventional Fuzzy C-means Clustering
clc;
clear;
im=imread('C:\Users\Administrator\Desktop\MRI.jpg');
subplot(1,2,1);imshow(im);title('Original Image')
imgray=rgb2gray(im);
[m,n]=size(imgray);

c=6;
pm=2;
u=zeros(c,m*n);
umin=zeros(c,m*n);
x=zeros(1,m*n);

for i=1:m
    for j=1:n
        x(1,(i-1)*n+j)=imgray(i,j);
    end
end

v=[23.3 25.55 160.5 80.5 255.3 200.6];

 for i=1:c     
        sumd=zeros(1,m*n);
        for k=1:c
            sumd=sumd+((x-v(i))./(x-v(k))).^2;
        end
        u(i,:)=1./sumd;
 end
 
 minJ=+inf;
 cot=0;
 
 while cot<20
    cot=cot+1;
    for i=1:c
        v(i)=((u(i,:).^2)*x')/sum(u(i,:).^2);
    end
    
     disp(v);

    for i=1:c     
        sumd=zeros(1,m*n);
        for k=1:c
           sumd=sumd+((x-v(i))./(x-v(k))).^2;
        end
        u(i,:)=1./sumd;
    end
    
    sumj=0;
    
    for k=1:c
        sumj=sumj+(u(k,:).^2)*((x-v(k)).^2)';
    end
    
   J=sumj;
   
    if minJ>J
        minJ=J;
        vmin=v;
        umin=u;
    end
 end
 
u=umin;
v=vmin;
disp(v);
f=double(imgray);

for i=1:m
    for j=1:n
        midv=abs(v-f(i,j));
        cenk=find(midv==min(midv));
        f(i,j)=v(cenk);
    end
end

subplot(1,2,2),imshow(uint8(f)),title('Conventional FCM');

figure, imshow(uint8(f));

cc=uint8(f);
ccc=color_coding(cc);
figure, imshow(ccc);