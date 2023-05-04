import java.util.Timer;
import java.util.TimerTask;

public class Clock
{
    protected static Clock clock;
    private Timer          timer;
    private CountDown      decrDown;

    public Clock(int time)
    {
        timer = new Timer();
        decrDown = new CountDown(time);
    }


    public void add(int extra)
    {
        decrDown.add(extra);
    }


    public void start()
        throws InterruptedException
    {
        timer.schedule(decrDown, 0, 9);
        synchronized (clock)
        {
            clock.wait();
            timer.cancel();
            System.out.println("out of time");
        }
        if (decrDown.time() <= 0)
        {
            timer.cancel();
        }
    }


    public double time()
    {
        return decrDown.time();
    }


    public static void main(String[] args)
        throws InterruptedException
    {
        clock = new Clock(6000);
        clock.start();
    }
}
