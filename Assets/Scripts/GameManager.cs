using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;
using System.Collections.Generic;
using System.Linq;

public class GameManager : MonoBehaviour
{
    public List<Vector3> pushPointV3s = new List<Vector3>(); 
    public List<Vector3> occupiedPointV3s = new List<Vector3>();
    public List<PushableBoxScript> pushableBoxes = new List<PushableBoxScript>();
    public int sceneInt;
    public static GameManager Instance
    {
        get
        {
            if (instance == null)
            {
                instance = FindObjectOfType<GameManager>();
            }
            return instance;
        }
        set
        {
            instance = value;
        }
    }
    private static GameManager instance;
    Keyboard thisKB =  new Keyboard();

    //public PushableBoxScript tempBoxScript;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        sceneInt = SceneManager.GetActiveScene().buildIndex;
        if (Instance != null && Instance != this)
        {
            Destroy(this);
        }
        else
        {
            Instance = this;
        }
        thisKB = Keyboard.current;
    }

    // Update is called once per frame
    void Update()
    {
        if (thisKB.rKey.wasPressedThisFrame)
        {
            SceneManager.LoadScene(sceneInt);
        }

        bool allBoxesSunk = pushableBoxes.All(script => script.isSuperComplete == true ? true : false);

        if (allBoxesSunk)
        {
            SceneManager.LoadScene(sceneInt+1);
        }
    }
}
