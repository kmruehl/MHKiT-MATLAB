function J=energy_flux(S,h,varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%    
%    Parameters
%    ------------
%    S: Spectral Density (m^2-s)
%           Pandas data frame
%       To make a pandas data frame from user supplied frequency and spectra
%       use py.pandas_dataframe.spectra_to_pandas(frequency,spectra)
%        OR
%        wave_spectra structure of form
%        wave_spectra.spectrum=Spectral Density (m^2-s;
%         wave_spectra.type=String of the spectra type, i.e. Bretschneider, 
%                time series, date stamp etc. ;
%         wave_spectra.frequency= frequency (Hz);
%    h: float
%         Water depth (m)
%
%     Optional 
%     ---------
%     NOTE: In matlab, if you set one optional parapeter, you must set
%     both, rho first, then g
%     rho: float
%         water density (kg/m^3)
%     g: float
%         gravitational acceleration (m/s^2)
%         
%
%     Returns
%     -------
%     J: double
%         Omni-directional wave energy flux (W/m)
%
%    Dependancies 
%    -------------
%    Python 3.5 or higher
%    Pandas
%    Scipy
%    Numpy
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[own_path,~,~] = fileparts(mfilename('fullpath'));
modpath= fullfile(own_path, '...');
P = py.sys.path;
if count(P,'modpath') == 0
    insert(P,int32(0),'modpath');
end

py.importlib.import_module('mhkit');


if (isa(S,'py.pandas.core.frame.DataFrame')~=1)
    if (isstruct(S)==1)
        S=py.pandas_dataframe.spectra_to_pandas(S.frequency,py.numpy.array(S.spectrum));
        
    else
        ME = MException('MATLAB:energy_flux','S needs to be a Pandas dataframe, use py.pandas_dataframe.spectra_to_pandas to create one');
        throw(ME);
    end
end

if nargin == 4 
    J=py.mhkit.wave.resource.energy_flux(S,h,pyargs('rho',varargin{1},'g',varargin{2}));
elseif nargin == 2
    J=py.mhkit.wave.resource.energy_flux(S,h);
else
    ME = MException('MATLAB:energy_flux','incorrect numner of arguments');
        throw(ME);
end


J=double(J.values);