function obj= GrowthObjective(p)
%load data
Data = readtable('../RawData/ActivatedWTSpleen.csv');
CellData = Data(:,{'NaiveCT', 'ActivatedCD4CT', 'AllTregs', ...                  
     'hours'}); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Make all changes here for optimization %%%%%%%%%%%%%%%%%
%                                                               %
DataUsed = [1, 2, 3]; 
% 1 = Naive CD4 T cells from Thymus
% 2 = Activated CD4 cells
% 3 = All Tregs
% 4 = Hours
% 5 = Naive Derived Tregs (only for the c parameter)
%The data location is equivalent in the ModelData df            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ModelData = SimulateGrowth(p);

%Setting up the hours
DataHours = unique(CellData.hours);

Rsquare = 0;
%ModelData = SimulateGrowth(p0);
for i = DataUsed
    %Calculates each data used at a time
    %Cell data numbers match 
    Cells = CellData(:,[i,4]); %Grabs data and hours
    SimulationData = ModelData(:,i);
    
    
    for j = 1:length(DataHours)                
      
        hour = DataHours(j);        
        CellDataIndex = Cells.hours == hour;
        CellDataForRSqr = Cells{CellDataIndex,1}; %Do not need hours anymore
        SimulationValue = SimulationData(hour);
        
        
        for h = 1:length(CellDataForRSqr)
            
            CellValue = CellDataForRSqr(h);
            %RSquareValue = (SimulationValue - CellValue).^2;
            RSquareValue = ((SimulationValue - CellValue)./CellValue).^2;
            Rsquare = Rsquare + RSquareValue;
           
        end

    end
    
end
disp(['Objective = ' num2str(Rsquare)])
obj = Rsquare;

    
