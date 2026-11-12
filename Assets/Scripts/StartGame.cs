using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class StartGame : MonoBehaviour
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    public Button thisButton;
    void Start()
    {
        Cursor.lockState = CursorLockMode.None;
        thisButton.onClick.AddListener(StartTheGame);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void StartTheGame()
    {
        SceneManager.LoadScene(1);
    }
}
