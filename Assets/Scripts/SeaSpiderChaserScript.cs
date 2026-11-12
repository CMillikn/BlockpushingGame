using System;
using System.Collections;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.SceneManagement;

public class SeaSpiderChaserScript : MonoBehaviour
{
    public NavMeshAgent seaspiderAgent;
    public GameObject playerGO;
    public PlayerMoveScript playerMoveScript;
    public bool canWalk;
    public float waitPeriod;
    public float agentSpeed;
    public Light testLight;
    public bool caughtPlayer;
    public GameObject jumpscareImage;
    public GameObject eyeBone;
    void Start()
    {
        jumpscareImage.SetActive(false);
        //StartCoroutine(Stalk());
    }

    // Update is called once per frame
    void Update()
    {
        seaspiderAgent.destination = playerGO.transform.position;
        
        eyeBone.transform.LookAt(playerGO.transform);
        if (canWalk)
        {
            seaspiderAgent.speed = agentSpeed;
        }

        else
        {
            seaspiderAgent.speed = 0;
        }
    }

    //IEnumerator Wait()
    //{
        //testLight.intensity = 2;
        //canWalk = false;
        //yield return new WaitForSeconds(waitPeriod);
        //StartCoroutine(Stalk());
    //}

    //IEnumerator Stalk()
    //{
        //testLight.intensity = 0;
        //canWalk = true;
        //yield return new WaitForSeconds(waitPeriod);
        //StartCoroutine(Wait());
    //}

    private void OnCollisionEnter(Collision other)
    {
        playerMoveScript = other.gameObject.GetComponent<PlayerMoveScript>();
        if (playerMoveScript != null)
        {
            jumpscareImage.SetActive(true);
            caughtPlayer = true;
            StartCoroutine(KillPlayer());
        }
    }

    IEnumerator KillPlayer()
    
    {
        yield return new WaitForSeconds(waitPeriod/4);
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }
}
