function V=discharge_to_velocity(D,polynomial_coefficients)

% Calculates velocity given discharge data and the relationship between 
%     discharge and velocity at an individual turbine
%     
%     Parameters
%     ------------
%     D : structure
%         Discharge data [m3/s] indexed by time [datetime or s]
%     polynomial_coefficients : numpy polynomial
%         List of polynomial coefficients that discribe the relationship between 
%         discharge and velocity at an individual turbine
%     
%     Returns   
%     ------------
%     V: pandas DataFrame   
%         Velocity [m/s] indexed by time [datetime or s]

[own_path,~,~] = fileparts(mfilename('fullpath'));
modpath= fullfile(own_path, '...');
P = py.sys.path;
if count(P,'modpath') == 0
    insert(P,int32(0),'modpath');
end

py.importlib.import_module('mhkit');

if (isa(D,'py.pandas.core.frame.DataFrame')~=1)
    x=size(D.Discharge);
    li=py.list();
    if x(2)>1 
        for i = 1:x(2)
            app=py.list(D.Discharge(:,i));
            li=py.pandas_dataframe.lis(li,app);
            
        end
    elseif x(2) ==1 
        li=D.Discharge;
    end
    
    if any(isdatetime(D.time{1}))
        si=size(D.time);
        for i=1:si(2)
        D.time{i}=posixtime(D.time{i});
        end
    end
    D=py.pandas_dataframe.timeseries_to_pandas(li,D.time,int32(x(2)));
end

polynomial_coefficients=py.numpy.poly1d(polynomial_coefficients);

Vdf=py.mhkit.river.resource.discharge_to_velocity(D,polynomial_coefficients);
disp(Vdf)


xx=cell(Vdf.axes);
v=xx{2};
vv=cell(py.list(py.numpy.nditer(v.values,pyargs("flags",{"refs_ok"}))));

vals=double(py.array.array('d',py.numpy.nditer(Vdf.values)));
sha=cell(Vdf.values.shape);
x=int64(sha{1,1});
y=int64(sha{1,2});

vals=reshape(vals,[x,y]);

si=size(vals);
 for i=1:si(2)
    test=string(py.str(vv{i}));
    newname=split(test,",");
    
    V.(newname(1))=vals(:,i);
    
 end
 V.time=double(py.array.array('d',py.numpy.nditer(Vdf.index)));
