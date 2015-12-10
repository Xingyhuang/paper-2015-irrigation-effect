function area = voronoi_valley()

cvs = load('cv_station_Tx.txt');
cvb = load('cv_boundary.txt');

[v,c] = voronoin(cvs);

n = 1000;

cvb_left = min(cvb(:,1));
cvb_bott = min(cvb(:,2));

cvb_right = max(cvb(:,1));
cvb_top   = max(cvb(:,2));

cvb(:,1) = (cvb(:,1) - cvb_left) / (cvb_right - cvb_left) * n;
cvb(:,2) = (cvb(:,2) - cvb_bott) / (cvb_top - cvb_bott) * n;

valleymask = poly2mask(cvb(:,1), cvb(:,2), n, n);
area = zeros(size(c,1),1);
for i = 1:size(c,1)
    cs = c{i};
    for j = 1:length(cs)
        if (cs(j) == 1)
            cs(j:length(cs)-1) = cs(j+1:length(cs));
            break;
        end
    end
    cvs = [];
    cvs(:,1) = (v(cs',1) - cvb_left) / (cvb_right - cvb_left) * n;
    cvs(:,2) = (v(cs',2) - cvb_bott) / (cvb_top - cvb_bott) * n;
    
    stationmask = poly2mask(cvs(:,1), cvs(:,2), n, n);
    
    area(i) = sum(sum(valleymask & stationmask));
end

area = area / sum(area);

disp(sprintf('Total area: %1.5e', sum(area)));
disp(sprintf('Valley area: %1.5e', sum(sum(valleymask))));