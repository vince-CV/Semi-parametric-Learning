% Spatial Information Related Fuzzy C-means Clustering

clc;
clear all;
close all;

im=imread('C:\Users\Administrator\Desktop\MRI.jpg');
subplot(1,2,1);imshow(im);title('Original Image');
imgray=im;
[m,n]=size(imgray);

c=6;
pm=2;
p=0;
q=2;

u=zeros(c,m*n);
u2=zeros(c,m*n);
umin=zeros(c,m*n);
x=zeros(1,m*n);

for i=1:m
    for j=1:n
        x(1,(i-1)*n+j)=imgray(i,j);  % transform the image into a 1-dimensional vector
    end
end

v=[23.3 50.6 160.5 80.5 255.3 200.6];  % initial guess of the each cluster center

for i=1:c
    sumd=zeros(1,m*n);
    for k=1:c
        sumd=sumd+((x-v(i))./(x-v(k))).^2;  
    end
    u(i,:)=1./sumd;    % membership function for each pixel
end

h=zeros(c,m*n);

 for cen=1:c
     for i=1:m*n
         xpos=fix(i/n)+1;
         ypos=mod(i,n);
         if xpos>2 && ypos>2 && n-xpos>2 && m-ypos>2
            sumh=0;
            for j=ypos-2:ypos+2
                for k=xpos-2:xpos+2
                    sumh=sumh+u(cen,(j-1)*n+k);    
                end
            end
            h(cen,i)=sumh;
         else
         h(cen,i)=u(cen,i);
         end
     end
 end
 
 minJ=+inf;
 cot=0;
 u2=(u.^p).*(h.^q);
 
wait=waitbar(0,'Calucating, Please wait...');

 while cot<10
     cot=cot+1;
     for i=1:c
         v(i)=((u2(i,:).^2)*x')/sum(u2(i,:).^2);  % updated cluster centers
     end
     disp(v);
     for i=1:c     
         sumd=zeros(1,m*n);
         for k=1:c
             sumd=sumd+((x-v(i))./(x-v(k))).^2;   % updated memebership function
         end
         u(i,:)=1./sumd;     % updated memebership function
     end
     h=zeros(c,m*n);
     for cen=1:c
         for i=1:m*n
             xpos=fix(i/n)+1;
             ypos=mod(i,n);
             if xpos>2 && ypos>2 && n-xpos>2 && m-ypos>2
                sumh=0;
                for j=ypos-2:ypos+2
                    for k=xpos-2:xpos+2
                        sumh=sumh+u(cen,(j-1)*n+k);       % the spatial information
                    end
                end
                h(cen,i)=sumh;
             else
                h(cen,i)=u(cen,i);
             end
         end
     end
     u2=(u.^p).*(h.^q);
     sumj=0;
     for k=1:c
         sumj=sumj+(u2(k,:).^2)*((x-v(k)).^2)';
     end
     J=sumj;
     if minJ>J
        minJ=J;
        vmin=v;
        umin=u2;
     end
     s=['Iterating: ' num2str(ceil(cot*100/10)) ' %'];
     waitbar(cot/10,wait,s);
 end
 
 u=umin;
 v=vmin;
 close(wait);
 
 disp(v);
 f=double(imgray);
 for i=1:m
     for j=1:n
         disp(u(:,i*j));
         midv=abs(v-f(i,j));
         cenk=find(midv==min(midv));
         f(i,j)=v(cenk);
     end
 end
subplot(1,2,2);imshow(uint8(f)),title('Spatial Information FCM (0 2)');

figure, imshow(uint8(f));
figure,subplot(1,2,1),imhist(imgray);
subplot(1,2,2),imhist(uint8(f));

p=uint8(f);
plate=zeros(m,n);
platev=zeros(m,n);
threshold=sort(v);

[count1 cc]=size(threshold);

for ss=1:c    
    for ii=1:m
        for jj=1:n
            if p(ii,jj)==round(threshold(ss))
                plate(ii,jj)=255;
            else
                plate(ii,jj)=0;
            end
        end
    end
    figure, imshow(uint8(plate));
     SB=uint8(f);
     S=color_coding(SB);
     figure, imshow(S);
end

for alpha=1:m
    for beta=1:n
        if (p(alpha, beta)==round(threshold(cc))) ||(p(alpha, beta)==round(threshold(cc-1)))
            platev(alpha,beta)=255;
        else
            platev(alpha,beta)=0;
        end
    end
end
figure, imshow(platev),title('combine');



            

