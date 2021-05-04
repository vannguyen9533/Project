function [] = animateDistance()
    close all;
    global gui;
    
    %create pop up window
    gui.fig = figure();
    
    %create the plot area
    gui.p = plot(0,0);
    gui.p.Parent.Position = [0.2 0.25 0.7 0.7];
    
    %create the radio buttons for the units with callback function
    gui.buttonGroup = uibuttongroup('visible','on','unit','normalized','position',[0 0.4 0.15 0.25],'selectionchangedfcn',{@radioSelect});
    gui.r1 = uicontrol(gui.buttonGroup,'style','radiobutton','units','normalized','position',[.1 .8 1 .2],'HandleVisibility','off','string','Steps');
    gui.r2 = uicontrol(gui.buttonGroup,'style','radiobutton','units','normalized','position',[.1 .5 1 .2],'HandleVisibility','off','string','Feet');
    gui.r3 = uicontrol(gui.buttonGroup,'style','radiobutton','units','normalized','position',[.1 .2 1 .2],'HandleVisibility','off','string','Meters');
    
    %create the scroll bar with callback function
    gui.scrollBar = uicontrol('style','slider','units','normalized','position',[.2 .1 .6 .05],'value',1,'min',1,'max',7,'sliderstep',[1/6 1/6],'callback',{@scrollbar});
    scrollbar();
    
    %create the animate button with callback function
    gui.animateButton = uicontrol('style','pushbutton','units','normalized','position',[.05 .05 .1 .1],'string','Animate','callback',{@animate});
end

%call back function for animate button
function [] = animate(~,~)
    global gui;
    
    %go through the 7 graphs of the week 
    %with 1s pause in between
    for i = 1:7
        gui.scrollBar.Value = i;
        scrollbar();
        pause(1);
    end
end

%callback function for the scrollbar
function [] = scrollbar(~,~)
    global gui;
    %plot the graph with the corresponding day of the week
    gui.scrollBar.Value = round(gui.scrollBar.Value);
    type = gui.buttonGroup.SelectedObject.String;
    plotSelectedDay(type);
end

%callback function for the unit buttons
function [] = radioSelect(~,~)
    global gui;
    %plot the graph with the corresponding unit
    type = gui.buttonGroup.SelectedObject.String;
    plotSelectedDay(type);
end

%plot function
function [] = plotSelectedDay(type)
    global gui;
    
    %read the data from the file
    data = readmatrix('distance.xlsx');
    dayListing = data(:,1);
    distance = data(:,2);
    
    %assign the day of the week with the scroll bar value
    currentDay = gui.scrollBar.Value;
    dayDistance = distance(dayListing == currentDay);
    
    %convert to the correct chosen unit
    if strcmp(type,'Feet')
        dayDistance = dayDistance*2.5;
    elseif strcmp(type,'Meters')
        dayDistance = dayDistance*0.762;
    end
    
    %plot the data on the graph with red and o
    gui.p = plot(1:length(dayDistance),dayDistance,'ro');
    
    %create title for the graph
    switch currentDay
        case 1
            dayString = 'Monday';
        case 2
            dayString = 'Tuesday';
        case 3 
            dayString = 'Wednesday';
        case 4
            dayString = 'Thursday';
        case 5
            dayString = 'Friday';
        case 6 
            dayString = 'Saturday';
        case 7
            dayString = 'Sunday';
    end
    title(['Walking Distance for ' dayString]);
end