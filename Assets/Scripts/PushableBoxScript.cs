using System;
using UnityEngine;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using TMPro;
using Vector3 = UnityEngine.Vector3;

public class PushableBoxScript : MonoBehaviour
{
    public bool isPushable = false;
    public PushBoxDetectionCollider northCollider;
    public PushBoxDetectionCollider southCollider; 
    public PushBoxDetectionCollider eastCollider;
    public PushBoxDetectionCollider westCollider;
    public Vector3 StartLocale;
    public Vector3 DestinationLocale;
    public float snapDistance;
    public float lerpSpeed;
    float increasingLerpSpeed;
    public float increaseAmount;
    public float fastLerpSpeed;
    public ParticleSystem scrapeCloud;
    public GameObject stopCloud;
    public Vector3 victoryPos;
    public GameObject victoryCloud;
    public GameObject victoryObj;
    public bool isComplete = false;
    public bool isSuperComplete = false;
    public float vanishSpeed;
    public GameObject occupiedPoint;
    public GameObject vacatedPoint;
    public string boxText;
    public List<TextMeshProUGUI>  boxTexts = new List<TextMeshProUGUI>();

    private void Start()
    {
        foreach (TextMeshProUGUI boxLetter in boxTexts)
        {
            boxLetter.text = boxText;
        }
        victoryPos = new Vector3(victoryObj.transform.position.x, 0.25f, victoryObj.transform.position.z);
        GameManager.Instance.pushableBoxes.Add(gameObject.GetComponent<PushableBoxScript>());
        occupiedPoint.SetActive(false);
        GameManager.Instance.occupiedPointV3s.Add(new Vector3(occupiedPoint.transform.position.x, 0.25f, occupiedPoint.transform.position.z));
    }

    public void Update()
    {
        if (transform.position == victoryPos)
        {
            isComplete = true;
            vacatedPoint.SetActive(true);
            occupiedPoint.SetActive(true);
        }
        if (isComplete != true)
        {
            if (isPushable == false)
            {
                vacatedPoint.SetActive(true);
                occupiedPoint.SetActive(false);
                scrapeCloud.Play();
                increasingLerpSpeed = increasingLerpSpeed + (increaseAmount * Time.deltaTime);
                if (Vector3.Distance(this.transform.position, DestinationLocale) > snapDistance)
                {
                    this.transform.position = Vector3.Lerp(this.transform.position, DestinationLocale, increasingLerpSpeed * Time.deltaTime);
                }
                //else if (Vector3.Distance(this.transform.position, DestinationLocale) > 0.1f)
                //{
                    //this.transform.position = Vector3.Lerp(this.transform.position, DestinationLocale, fastLerpSpeed * Time.deltaTime );
                //}
                else
                {
                    this.transform.position = DestinationLocale;
                    Instantiate(stopCloud, transform.position, transform.rotation);
                }
                
            }
    
            if (this.transform.position == DestinationLocale)
            {
                isPushable = true;
                
                scrapeCloud.Stop();
                if (this.transform.position == victoryPos)
                {
                    Instantiate(victoryCloud, new Vector3(transform.position.x, 0, transform.position.z), transform.rotation);
                }
            }
        }
        else
        {
            isPushable = false;
            CompleteVanish();
        }
    }

    public void CompleteVanish()
    {
        if (transform.position.y >= -3)
        {
            GameManager.Instance.occupiedPointV3s.Remove(new Vector3(occupiedPoint.transform.position.x, 0.25f,
                occupiedPoint.transform.position.z));
            transform.position = new Vector3(transform.position.x,transform.position.y - vanishSpeed,transform.position.z);
            vanishSpeed = vanishSpeed+(Time.deltaTime * 0.1f);
        }
        else
        {
            isSuperComplete = true;
        }
    }

    public void PushObjectNorth()
    {
        if (isPushable)
        {
            if (northCollider.isColliding)
            {
                Vector3 interesctionPoint = new Vector3(northCollider.pushPoint.transform.position.x, 0.25f,
                    northCollider.pushPoint.transform.position.z);
                if (!GameManager.Instance.occupiedPointV3s.Contains(interesctionPoint))
                {
                  vacatedPoint = occupiedPoint;
                  occupiedPoint = northCollider.pushPoint;
                  GameManager.Instance.occupiedPointV3s.Add(new Vector3(occupiedPoint.transform.position.x, 0.25f, occupiedPoint.transform.position.z));
                  GameManager.Instance.occupiedPointV3s.Remove(new Vector3(vacatedPoint.transform.position.x, 0.25f,
                      vacatedPoint.transform.position.z));
                  isPushable = false;
                  increasingLerpSpeed = lerpSpeed;
                  StartLocale = new Vector3(this.transform.position.x, 0.25f, this.transform.position.z);
                  DestinationLocale = new  Vector3(northCollider.pushPoint.transform.position.x, 0.25f, northCollider.pushPoint.transform.position.z);  
                }
            }
    
            else
            {
                Instantiate(stopCloud, transform.position, transform.rotation);
                Debug.Log("Nope, no points to go to!");
            }
        }
    }

    public void PushObjectSouth()
    {
        if (isPushable)
        {
            if (southCollider.isColliding)
            {
                Vector3 interesctionPoint = new Vector3(southCollider.pushPoint.transform.position.x, 0.25f,
                    southCollider.pushPoint.transform.position.z);
                if (!GameManager.Instance.occupiedPointV3s.Contains(interesctionPoint))
                {
                    vacatedPoint = occupiedPoint;
                    occupiedPoint = southCollider.pushPoint;
                    GameManager.Instance.occupiedPointV3s.Add(new Vector3(occupiedPoint.transform.position.x, 0.25f, occupiedPoint.transform.position.z));
                    GameManager.Instance.occupiedPointV3s.Remove(new Vector3(vacatedPoint.transform.position.x, 0.25f,
                        vacatedPoint.transform.position.z));
                    isPushable = false;
                    increasingLerpSpeed = lerpSpeed;
                    StartLocale = new Vector3(this.transform.position.x, 0.25f, this.transform.position.z);
                    DestinationLocale = new  Vector3(southCollider.pushPoint.transform.position.x, 0.25f, southCollider.pushPoint.transform.position.z);
                }

            }
    
            else
            {
                Instantiate(stopCloud, transform.position, transform.rotation);
                Debug.Log("Nope, no points to go to!");
            }
        }
    }

    public void PushObjectEast()
    {
        if (isPushable)
        {
            if (eastCollider.isColliding)
            {
                Vector3 interesctionPoint = new Vector3(eastCollider.pushPoint.transform.position.x, 0.25f,
                    eastCollider.pushPoint.transform.position.z);
                if (!GameManager.Instance.occupiedPointV3s.Contains(interesctionPoint))
                {
                    vacatedPoint = occupiedPoint;
                    occupiedPoint = eastCollider.pushPoint;
                    GameManager.Instance.occupiedPointV3s.Add(new Vector3(occupiedPoint.transform.position.x, 0.25f, occupiedPoint.transform.position.z));
                    GameManager.Instance.occupiedPointV3s.Remove(new Vector3(vacatedPoint.transform.position.x, 0.25f,
                        vacatedPoint.transform.position.z));
                    isPushable = false;
                    increasingLerpSpeed = lerpSpeed;
                    StartLocale = new Vector3(this.transform.position.x, 0.25f, this.transform.position.z);
                    DestinationLocale = new  Vector3(eastCollider.pushPoint.transform.position.x, 0.25f, eastCollider.pushPoint.transform.position.z);
                }
            }
    
            else
            {
                Instantiate(stopCloud, transform.position, transform.rotation);
                Debug.Log("Nope, no points to go to!");
            }
        }
    }

    public void PushObjectWest()
    {
        if (isPushable)
        {
            if (westCollider.isColliding)
            {
                Vector3 interesctionPoint = new Vector3(westCollider.pushPoint.transform.position.x, 0.25f,
                    westCollider.pushPoint.transform.position.z);
                if (!GameManager.Instance.occupiedPointV3s.Contains(interesctionPoint))
                {
                   vacatedPoint = occupiedPoint;
                   occupiedPoint = westCollider.pushPoint;
                   GameManager.Instance.occupiedPointV3s.Add(new Vector3(occupiedPoint.transform.position.x, 0.25f, occupiedPoint.transform.position.z));
                   GameManager.Instance.occupiedPointV3s.Remove(new Vector3(vacatedPoint.transform.position.x, 0.25f,
                       vacatedPoint.transform.position.z));
                   isPushable = false;
                   increasingLerpSpeed = lerpSpeed;
                   StartLocale = new Vector3(this.transform.position.x, 0.25f, this.transform.position.z);
                   DestinationLocale = new  Vector3(westCollider.pushPoint.transform.position.x, 0.25f, westCollider.pushPoint.transform.position.z); 
                }
            }
    
            else
            {
                Instantiate(stopCloud, transform.position, transform.rotation);
                Debug.Log("Nope, no points to go to!");
            }
        }
    }
}
