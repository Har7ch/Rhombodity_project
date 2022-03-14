I = imread("C:\Users\DELL\OneDrive\Desktop\proj-1.jpeg");
rotI = imrotate(I,33,'crop');
%imshow(rotI)
gray=rgb2gray(I);
BW = edge(gray,'canny');
% [BW,maskedImage] = segmentImage(I);
% imshow(BW);
[H,theta,rho] = hough(BW);
figure
imshow(imadjust(rescale(H)),[],...
       'XData',theta,...
       'YData',rho,...
       'InitialMagnification','fit');
xlabel('\theta (degrees)')
ylabel('\rho')
axis on
axis normal 
hold on
colormap(gca,hot)
P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = theta(P(:,2));
y = rho(P(:,1));
plot(x,y,'s','color','black');
lines = houghlines(BW,theta,rho,P,'FillGap',5,'MinLength',7);
figure, imshow(BW), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   x1=xy(1,1);y1=xy(1,2);
   x2=xy(2,1);y2=xy(2,2);
   
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   
%    extending

    pto1 = [x1 y1];  
    pto2 = [x2 y2];
    % A vector along the ray from pto1 to pto2...
    V  = pto2 - pto1;
    V2 = pto1 - pto2;
    % The distance between the points would be:
      dist12 = norm(V);
    % but there is no need to compute it.
    % which will be extended (by 20% in this case) here
    factor_distance = dist12;
    % Extend the ray
    pext = pto1 + V*factor_distance;
    pext2= pto2 + V2*factor_distance;
    % plot...
    plot([pto1(1),pto2(1)],[pto1(2),pto2(2)],'ro',[pto1(1),pext(1)],[pto1(2),pext(2)],'b-',...
    [pto2(1),pext2(1)],[pto2(2),pext2(2)],'b-')

% % % % % % % % % % % 

   % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
% highlight the longest line segment
% plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
