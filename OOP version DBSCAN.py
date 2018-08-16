# -*- coding: utf-8 -*-
"""
Created on Thu Aug 16 10:06:33 2018

@author: Administrator
"""

from sklearn.metrics.pairwise import euclidean_distances
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


class DBSCAN(object):
    
    def __init__(self, dataSet, epsilon, minPts):
        
        data=pd.DataFrame(columns=['X','Y'])
        data['X']=dataSet[:,1]
        data['Y']=dataSet[:,2]
        dataset=np.vstack((dataSet[:,1],dataSet[:,2])).T
        
        self.__dataset=dataset
        self.__data=data.reset_index(drop=True)
        self.__epsilon=epsilon
        self.__minPts=minPts
    
    def eu_distance(self,dataset):
        return euclidean_distances(dataset)
    
    def noise(self):
        dist=self.eu_distance(self.__data)
        ptses = []
        
        for row in dist:
            density = np.sum(row < self.__epsilon)
            pts = 0
            if density > self.__minPts:
                pts = 1
            elif density > 1:
                pts = 2
            else:
                pts = 0
        
            ptses.append(pts)
            
        corePoints = self.__data[pd.Series(ptses)!=0]  # De-noise points
        noisePoints = self.__data[pd.Series(ptses)==0] # Noise Points
        
        return corePoints, noisePoints
    
    def cluster_grow(self):
        
        core, noise = self.noise()
        coreDist = self.eu_distance(core) 
        cluster = dict()
        
        m = 0
        for row in coreDist: 
            cluster[m] = np.where(row < self.__epsilon)[0]
            m = m + 1

        for i in range(len(cluster)):
            for j in range(len(cluster)):
                if len( set(cluster[j]) & set(cluster[i]) ) > 0 and i!=j:
                    cluster[i] = list(set(cluster[i]) | set(cluster[j]))
                    cluster[j] = list()

        result = dict()
        n = 0
        for i in range(len(cluster)):
            if len(cluster[i])>10:
                result[n] = cluster[i]
                n = n + 1
                
        return result,noise
    
    @property
    def visualize(self):
        results, noisePts = self.cluster_grow()

        color = ['or', 'ob', 'oy', 'om', 'oc', '*k']   
        ind = 0
        plt.figure(figsize=(6,4.8))
        plt.title('DBSCAN Clustering Results (epsilon=5, minpts=5)')
        plt.xlabel('Distance')
        plt.ylabel('Speed')      
        for i in range(len(results)):
            for j in results[i]:
                flag = j
                plt.plot(self.__dataset[flag,0], self.__dataset[flag,1], color[i], markersize=2)
                ind = ind + 1

        apos = np.array(noisePts['X'])
        bpos = np.array(noisePts['Y'])

        for i in range(len(apos)):
            plt.plot(apos[i], bpos[i], color[5], markersize=6)

        plt.grid()
        plt.show()

        
        
if __name__ == '__main__':
    clustering = DBSCAN(np.loadtxt('driverlog.txt'), 5, 5)
    clustering.visualize