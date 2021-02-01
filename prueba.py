plt.hist(my_data["Happiness Score"], bins=15, edgecolor ='white') 
#x and y labels:
plt.xlabel("Frequency")
plt.ylabel("Happiness Score")
textstr= 'Mean = 5.375734\nS.D =1.145010\nn = 158'
plt.text(40,50, textstr)
#para hacer lineas
plt.axvline(x=5.375734,color='red',linestyle="dashed", label='mean')
plt.axvline(x=5.3757348 + 1.145010,color='green',linestyle="solid", label='S.D.')
plt.axvline(x=5.375734 - 1.145010,color='green',linestyle="solid")
plt.legend(loc='center right')
plt.show()