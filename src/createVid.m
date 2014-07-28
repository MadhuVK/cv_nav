function video = createVid()
vid = videoinput('winvideo');
set(vid,'TriggerRepeat', Inf);
vid.FrameGrabInterval = 5;
video.vid = vid; 
start(vid);
end

