%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reads GMSH file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%==  New variables after calling this script ==%
%=      NN,NE,NL
%=      nodes,elements,loads
%=      nsolid,ndbc,nbcdn,ntbc
%=              dbc, bcdn, tbc
%=      nodenum

fmid=fopen(mshfile,'r');            % opens mesh file

tline = fgets(fmid);                % reads a series of lines in preamble
tline = fgets(fmid); 
tline = fgets(fmid); 
tline = fgets(fmid); 

tline = fgets(fmid);                % gets string with number of nodes NN
NN=sscanf(tline,'%d');              % reads NN from string
position = ftell(fmid);             % memorizes position in mesh file
nodenum=zeros(NN,1);
for i=1:NN,                         % loop lines of section $Nodes
    tline = fgets(fmid); 
    h=sscanf(tline,'%d %f %f %f')';    % h contains node number and 3 coords
    nodenum(i)=h(1);                   % saves the node number in nodenum 
end

maxnodenum=max(nodenum);
fseek(fmid, position, 'bof');

% If dof >  0 , dof -> Global number of the unknown nodal value
% If dof = -1 , the nodal value is prescribed

nodes=repmat(struct('coor',[],...  % allocates the list nodes
                    'dof',[],...
                    'U',[]),1,maxnodenum);

for i=1:NN,                         % loop to read the nodes
    
    tline = fgets(fmid); 

    h=sscanf(tline,'%d %f %f %f')';    % reads node number and 3 coordinates

    nodes(h(1)).coor=h(2:1+DG);        % saves coordinates

    nodes(h(1)).dof = zeros(1,ndof);
    
    nodes(h(1)).U = zeros(1,ndof);
    
end

analysis.NN=NN;                     % save number of nodes

nsolid=numel(solid(:,1));           % number of sets assoc. to materials

ndbc=0; ndbcn=0; ntbc=0; ncbc=0;

if exist('dbc')
    ndbc=numel(dbc(:,1));        % number of sets with imposed displacement bc
else    
    dbc=0;
end

if exist('tbc') 
    ntbc=numel(tbc(:,1));        % number of sets with imposed traction bc
else
    tbc=0;   
end

if exist('dbcn')  
    ndbcn=numel(dbcn(:,1));      % number of nodes with imposed displacement bc
end 

if exist('cbc')
    ncbc=numel(cbc(:,1));
else
    cbc=0;
end

tline = fgets(fmid); 
tline = fgets(fmid); 

NE=0;
NL=0;
NC=0;

tline = fgets(fmid);                % string with the number of elements
num=sscanf(tline,'%d');             % reads the global number of elements

eltype=zeros(num,2);
position = ftell(fmid);             % memorizes position in mesh file


epps = [0 0 0 0 0 0 0 0 0 0 0 0 0];

for i=1:num
    
    tline = fgets(fmid);         
    h=sscanf(tline,'%d')';
    
    physet=h(4);                    % physical set

    epps(physet) = epps(physet)+1;
    
    % If finds the physical set inside the tab solid
    %    -> Returns the index ( integer )
    % Else
    %    -> Returns []
    
    pos=find(solid(:,1)==physet);
    if ~isempty(pos)
        
        NE=NE+1;
        
        eltype(i,:) = [1 pos];
        
    else
        
        pos=find(tbc(:,1)==num2str(physet));
        NL = NL+length(pos);
        
        pos=find(cbc(:,1)==num2str(physet));
        NC = NC+length(pos);

        if(length(pos)>0)
            eltype(i,:) = [3 0];
        else
            eltype(i,:) = [2 0];
        end
        
        
        %  Remplit les conditions au bord de Dirichlet
        pos=find(dbc(:,1)==num2str(physet));
        for iL=1:length(pos)
            for n=6:length(h)

                x = nodes(h(n)).coor(1);
                y = nodes(h(n)).coor(2);
                
                % pos(iL) = index of the dbc elements who has the physet
                % dbc(pos(iL),2) = Direction of the condition
                % dbc(pos(iL),3) = Value of the condition
                
                dir = str2num(dbc(pos(iL),2));
                
                nodes(h(n)).dof( dir ) = -1;
                
                nodes(h(n)).U(dir) = eval(dbc(pos(iL),3));
                
            end
        end
    end
    
end

fseek(fmid, position, 'bof');

elements=repmat(struct('type',0,...   % allocates list of elements 
                       'mat',0,...
                       'nodes',[]),1,NE);

loads=repmat(struct('type',0,...      % allocates list of loads
                    'nodes',[],...
                    'dir',0,...
                    'val',0,...
                    'mat',0),1,NL);

frontiere = repmat(struct('type',0,...
                          'nodes',[],...
                          'left_material',0,...
                          'right_material',0,...
                          'jump_function'," "),1,NC);

disp("Elements per physical set");
disp(epps);

NE=0;
NL=0;
NC=0;

for i=1:num,             
    tline = fgets(fmid);         
    h=sscanf(tline,'%d')';
    physet=h(4);                         % physical set
    pos=eltype(i,2);
    
    switch eltype(i,1)
        
      case 1,

        % The element is a material one 
        NE=NE+1;
       
        elements(NE).type=h(2);             % element type 
        elements(NE).mat=solid(pos,2);      % element material 
        elements(NE).nodes=h(6:length(h));  % connectivity of the element
        
      case 2,

        % The element is the support of one or more loads
        pos=find(tbc(:,1)==num2str(physet));
        
        for iL=1:length(pos)
            NL=NL+1;
            
            loads(NL).type = h(2);            
            loads(NL).nodes = h(6:length(h));
            loads(NL).dir = str2num(tbc(pos(iL),2));
            loads(NL).val = tbc(pos(iL),3);
            loads(NL).mat = str2num(tbc(pos(iL),4));
        end
        
      case 3,
        
        % The node is continuous
        pos=find(cbc(:,1)==num2str(physet));
        
        NC = NC+1;
        
        frontiere(NC).type = h(2);
        
        frontiere(NC).nodes = h(6:length(h));
        
        frontiere(NC).left_material = str2num(cbc(pos,2));
        frontiere(NC).right_material = str2num(cbc(pos,3));
        
        frontiere(NC).jump_function = cbc(pos,4);
        
    end
end

analysis.NE = NE;
analysis.NL = NL;
analysis.NC = NC;

% Isolated nodes
for j=1:ndbcn
    
    nodes(dbcn(j,1)).dof(dbcn(j,2))=dof_D;
    dof_D = dof_D-1;
    
    nodes(dbcn(j,1)).U(dbcn(j,2))=dbcn(j,3);
    
end    

fclose(fmid);

clear eltype nodenum

