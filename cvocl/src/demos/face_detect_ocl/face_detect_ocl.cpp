// WARNING: this sample is under construction! Use it on your own risk.
#if defined _MSC_VER && _MSC_VER >= 1400
#pragma warning(disable : 4100)
#endif

#include <iostream>
#include <iomanip>
#include <stdexcept>

#include <opencv2/contrib/contrib.hpp>
#include <opencv2/objdetect/objdetect.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
//#include <opencv2/gpu/gpu.hpp>
#include<opencv2/ocl/ocl.hpp>
#include "utility_lib/utility_lib.h"

using namespace std;
using namespace cv;
using namespace cv::ocl;
//using namespace cv::gpu;
struct getRect { Rect operator ()(const CvAvgComp& e) const { return e.rect; } };
class App : public BaseApp
{
public:
    App() : useGPU(true), scaleFactor(1.), findLargestObject(false), 
            filterRects(true), helpScreen(false) {}

protected:
    void process();
    bool parseCmdArgs(int& i, int argc, const char* argv[]);
    bool processKey(int key);
    void printHelp();

private:
    string cascade_name;
    cv::ocl::OclCascadeClassifier cascade_gpu;
    CascadeClassifier cascade_cpu;

    /* parameters */
    bool useGPU;
    double scaleFactor;
    bool findLargestObject;
    bool filterRects;
    bool helpScreen;
};

template<class T> void convertAndResize(const T& src, T& gray, T& resized, double scale)
{
    if (src.channels() == 3)
        cvtColor(src, gray, COLOR_BGR2GRAY);
    else if (src.channels() == 4)
        cvtColor(src, gray, COLOR_BGRA2GRAY);
    else
        gray = src;

    Size sz(cvRound(gray.cols * scale), cvRound(gray.rows * scale));

    if (scale != 1)
        resize(gray, resized, sz);
    else
        resized = gray;
}

void displayState(Mat& canvas, bool bHelp, bool bGpu, bool bLargestFace, bool bFilter, double fps)
{
    Scalar fontColorRed = CV_RGB(255, 0, 0);
    Scalar fontColorNV  = CV_RGB(118, 185, 0);

    ostringstream ss;
    ss << "FPS = " << setprecision(1) << fixed << fps;
    printText(canvas, ss.str(), 0, fontColorRed);

    ss.str("");
    ss << "[" << canvas.cols << "x" << canvas.rows << "], " <<
        (bGpu ? "OCL, " : "CPU, ") <<
        (bLargestFace ? "OneFace, " : "MultiFace, ") <<
        (bFilter ? "Filter:ON" : "Filter:OFF");
    printText(canvas, ss.str(), 1, fontColorRed);

    if (!bHelp)
        printText(canvas, "H - toggle hotkeys help", 2, fontColorNV);
    else
    {
        printText(canvas, "Space - switch OCL / CPU", 2, fontColorNV);
        printText(canvas, "M - switch OneFace / MultiFace", 3, fontColorNV);
        printText(canvas, "F - toggle rectangles Filter", 4, fontColorNV);
        printText(canvas, "H - toggle hotkeys help", 5, fontColorNV);
        printText(canvas, "1/Q - increase/decrease scale", 6, fontColorNV);
    }
}

void App::process()
{
    if (cascade_name.empty())
    {
        cout << "Using default cascade file...\n";
        cascade_name = "data/face_detect/haarcascade_frontalface_alt.xml";
    }

    if (!cascade_gpu.load(cascade_name) || !cascade_cpu.load(cascade_name))
    {
        ostringstream msg;
        msg << "Could not load cascade classifier \"" << cascade_name << "\"";
        throw runtime_error(msg.str());
    }

    if (sources.size() != 1)
    {
        cout << "Loading default frames source...\n";
        sources.resize(1);
        sources[0] = new VideoSource("data/face_detect/browser.flv");
        cout << "loaded data/face_detect/browser.flv\n";
    }

    Mat frame, frame_cpu, gray_cpu, resized_cpu, faces_downloaded, frameDisp, img/*add img*/;
    vector<Rect> facesBuf_cpu;
    vector<Rect> faces;
    vector<CvAvgComp> vecAvgComp;

    cv::ocl::oclMat/*GpuMat*/ frame_gpu, gray_gpu, resized_gpu,facesBuf_gpu;
	const static Scalar colors[] =  { CV_RGB(0,0,255),
		CV_RGB(0,128,255),
		CV_RGB(0,255,255),
		CV_RGB(0,255,0),
		CV_RGB(255,128,0),
		CV_RGB(255,255,0),
		CV_RGB(255,0,0),
		CV_RGB(255,0,255)} ;


    int detections_num;

    while (!exited)
    {
        sources[0]->next(frame_cpu);
        frame_gpu.upload(frame_cpu);

        convertAndResize(frame_gpu, gray_gpu, resized_gpu, scaleFactor);
        convertAndResize(frame_cpu, gray_cpu, resized_cpu, scaleFactor);

        TickMeter tm;
        tm.start();
        if (useGPU)
        {
			double scale = 1;
			cv::ocl::oclMat image(frame_gpu);
			cv::ocl::oclMat gray, resized_gpu( cvRound (frame_gpu.rows/scale), cvRound(frame_gpu.cols/scale), CV_8UC1 );
			cv::ocl::cvtColor( image, gray, CV_BGR2GRAY );

			cv::ocl::resize( gray, resized_gpu, resized_gpu.size(), 0, 0, INTER_LINEAR );
			cv::ocl::equalizeHist( resized_gpu, resized_gpu );
			CvSeq* _objects;

  			MemStorage storage(cvCreateMemStorage(0));
			_objects = cascade_gpu.oclHaarDetectObjects( resized_gpu, storage, 1.2, 
				3, /*0|CV_HAAR_SCALE_IMAGE*/(findLargestObject) ? 4 : 0, 
				Size(30,30), Size(0, 0) );
			
			Seq<CvAvgComp>(_objects).copyTo(vecAvgComp);
			faces.resize(vecAvgComp.size());
			std::transform(vecAvgComp.begin(), vecAvgComp.end(), faces.begin(), getRect());
			//find face num
			detections_num=(int)vecAvgComp.size();
        }
        else
        {
            //Size minSize = cascade_gpu.getClassifierSize();
            Size minSize = cascade_gpu.getOriginalWindowSize();
            cascade_cpu.detectMultiScale(resized_cpu, facesBuf_cpu, 1.2,
                                         (filterRects || findLargestObject) ? 4 : 0,
                                         (findLargestObject ? CV_HAAR_FIND_BIGGEST_OBJECT : 0)
                                            | CV_HAAR_SCALE_IMAGE,
                                         minSize);
            detections_num = (int)facesBuf_cpu.size();
        }
	//CPU Paint rectangle
        if (!useGPU && detections_num)
        {
            for (int i = 0; i < detections_num; ++i)
            {
                rectangle(resized_cpu, facesBuf_cpu[i], Scalar(255));
            }
        }
        else if(useGPU && detections_num)
	{
		for(int i=0; i<detections_num; i++)
		{
			rectangle(resized_cpu, vecAvgComp[i].rect, Scalar(255));
		}
	}
//          if (useGPU)
//          {
//              resized_gpu.download(resized_cpu);
//          }

        tm.stop();
        double detectionTime = tm.getTimeSec();
        double fps = 1.0 / detectionTime;

        cvtColor(resized_cpu, frameDisp, CV_GRAY2BGR);
        displayState(frameDisp, helpScreen, useGPU, findLargestObject, filterRects, fps);
        imshow("face_detect_demo", frameDisp);

        processKey(waitKey(3));
    }
}

bool App::parseCmdArgs(int& i, int argc, const char* argv[])
{
    if (string(argv[i]) == "--cascade")
    {
        ++i;

        if (i >= argc)
            throw runtime_error("Missing file name after --cascade");

        cascade_name = argv[i];

        return true;
    }

    return false;
}

bool App::processKey(int key)
{
    if (BaseApp::processKey(key))
        return true;

    switch (toupper(key & 0xff))
    {
    case 32 /*space*/:
        useGPU = !useGPU;
        break;

    case 'M':
        findLargestObject = !findLargestObject;
        break;

    case 'F':
        filterRects = !filterRects;
        break;

    case '1':
        scaleFactor *= 1.05;
        break;

    case 'Q':
        scaleFactor /= 1.05;
        break;

    case 'H':
        helpScreen = !helpScreen;
        break;

    default:
        return false;
    }

    return true;
}

void App::printHelp()
{
    cout << "Usage: demo_face_detect --cascade <cascade_file> <frames_source>\n";
    BaseApp::printHelp();
}

RUN_APP(App)
