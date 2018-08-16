# -*- coding: utf-8 -*-
"""
Created on Thu Aug 16 10:07:34 2018

@author: Xunzhe Wen
"""

import numpy as np
import math
import pandas as pd
import matplotlib.pyplot as plt
from scipy.spatial import distance_matrix

class K_means(object):
    
    __slots__ = ('__data', '__k_value')
    
    def __init__(self, data, k_value):
        distance=data[:,1]
        speed=data[:,2]
        dataSet=np.vstack((distance,speed)).T
        
        self.__data = dataSet
        self.__k_value = k_value
    
    def k_means(self, data, k):  

        row=data.shape[0]
        col=data.shape[1]
        init_index = np.random.choice(row, k, replace=False)
        current = data[init_index]
        previous = np.zeros((k,col))
        c_info = np.zeros(row)

        while (previous != current).any():
            previous = current.copy()
            eDistance = distance_matrix(data, current, p=2)
            
            for i in range(row):
                dist = eDistance[i]
                nearest = (np.where(dist==np.min(dist)))[0][0]
                c_info[i] = nearest
            for j in range(k):
                p = data[c_info == j]
                current[j]=np.apply_along_axis(np.mean, axis=0, arr=p)
                
        return (current, c_info)
    
    @property
    def visualize(self):
    
        centroids,clusters = self.k_means(self.__data,self.__k_value)
        
        color1 = ['or', 'ob', 'oy', 'om', 'oc']  
        color2 = ['*k', '*k', '*k', '*k', '*k'] 
        plt.figure(figsize=(6,4.8))
        plt.title('K-Means Clustering Results (K=5)')
        plt.xlabel('Distance')
        plt.ylabel('Speed')
        
        row=self.__data.shape[0]
        
        for i in range(row):
            colorIndex = int(clusters[i])  
            plt.plot(self.__data[i, 0], self.__data[i, 1], color1[colorIndex], markersize=2)   
        
        for i in range(self.__k_value):  
            plt.plot(centroids[i, 0], centroids[i, 1], color2[i], markersize = 10)
            
        plt.grid()
        plt.show()  

        
        
if __name__ == '__main__':
    clustering = K_means(np.loadtxt('driverlog.txt'), 5)
    clustering.visualize

