function mg = mgvideosample(varargin)
% function mg = mgvideosample(varargin)
% mgvideosample the video in the spatial view for the sake of memory.
% syntax: mg = mgvideosample(mg,factor,newfilename)
% mg = mgvideosample(file)
% mg = mgvideosample(file,factor)
% mg = mgvideosample(file,factor,newfilename)
% mg = mgvideosample(mg,factor,newfilename)
% mg = mgvideosample(mg,factor)
% input:
% mg: musical gestures structure or an image
% factor: sampling factor,default value,[2,2],the first value is row sampling
% factor, the second value is column sampling factor
% filename: the file name of sampled video, required format .avi
% output:
% mg:sampled mg 


if isempty(varargin)
    return;
end
if length(varargin) == 3
   factor = varargin{2};
   filename = varargin{3};
elseif length(varargin) == 2
   filename = 'samplevideo.avi';
   factor = varargin{2};
elseif length(varargin) == 1;
    filename = 'samplevideo.avi';
    factor = [2,2];
end
if isstruct(varargin{1}) && isfield(varargin{1},'video') 
    mg = varargin{1};
    mg.video.obj.CurrentTime = mg.video.starttime;
    v = VideoWriter(filename);
    v.FrameRate = mg.video.obj.FrameRate;
    open(v);
    i = 1;
    numf = floor((mg.video.endtime-mg.video.starttime)*mg.video.obj.FrameRate);
    while mg.video.obj.CurrentTime < mg.video.endtime
        progmeter(i,numf);
        tmp = readFrame(mg.video.obj);
        tmp = rgb2gray(tmp);
        tmp = tmp(1:factor(1):end,1:factor(2):end);
        writeVideo(v,tmp);
        i = i + 1;
    end
    close(v)
    s = mgvideoreader(filename);
    mg.video.obj = s.video.obj;
    mg.video.starttime = 0;
    mg.video.endtime = s.video.obj.Duration;
elseif ischar(varargin{1})
    file =varargin{1};
    [~,~,ex] = fileparts(file);
    if ismember(ex,{'.mp4';'.mov';'.avi';'.mpg';'.m4v'})
        mg = mgvideoreader(file);
        v = VideoWriter(filename);
        v.FrameRate = mg.video.obj.FrameRate;
        open(v);
        i = 1;
        numf = floor(mg.video.obj.FrameRate*mg.video.obj.Duration);
        while mg.video.obj.CurrentTime < mg.video.endtime
            progmeter(i,numf);
            tmp = rgb2gray(readFrame(mg.video.obj));
            tmp = tmp(1:factor(1):end,1:factor(2):end);
            writeVideo(v,tmp);
            i = 1 + i;
        end
        close(v);
        mg = mgvideoreader(filename);
    end  
end

    
    
        
    
    
    