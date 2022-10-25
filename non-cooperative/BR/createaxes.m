function createaxes(Parent, i, iterations, a)
%CREATEAXES(Parent, iterations, a)
%  Parent:  axes parent
%  iterations:  scatter x
%  a:  scatter y

%  Auto-generated by MATLAB on 20-Oct-2022 19:26:09
row = fix((i-1)/3);
col = mod(i-1,3);
% Create axes
    axes1 = axes('Parent',Parent,...
        'Position',[0.218710493046776+0.2807*col 0.82095006090134-0.22*row 0.11251580278129 0.0767356881851401]);

% if col == 2
%     axes1 = axes('Parent',Parent,...
%         'Position',[0.49936788874842-0.2807 0.82095006090134-0.22*row 0.11251580278129 0.0767356881851401]);
% elseif col == 1
%      axes1 = axes('Parent',Parent,...
%     'Position',[0.49936788874842+0.2807 0.82095006090134-0.22*row 0.11251580278129 0.0767356881851401]);  
% else
%      axes1 = axes('Parent',Parent,...
%     'Position',[0.49936788874842 0.82095006090134-0.22*row 0.11251580278129 0.0767356881851401]);  
%     
% end

hold(axes1,'on');

% Create scatter
scatter(iterations,a,...
    'Parent',axes1,...
    'LineWidth',2);

% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0 0.03]);
box(axes1,'on');
hold(axes1,'off');
% Set the remaining axes properties
set(axes1,'FontSize',14,'FontWeight','bold','XTick',[2 3 4 5 6]);