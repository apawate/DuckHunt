import java.util.TimerTask;

public class CountDown
    extends TimerTask
{
    private int time;

    public CountDown(int time)
    {
        this.time = time;
    }


    public int time()
    {
        return time;
    }


    public void add(int cseconds)
    {
        this.time += cseconds;
    }


    public void run()
    {
        time -= 1;
        System.out.println((double)time / 100);

        if (time == 0)
        {
            synchronized (Clock.clock)
            {
                Clock.clock.notify();
            }
        }
    }
}
